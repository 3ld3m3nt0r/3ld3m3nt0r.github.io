require 'base64'
require 'digest'
require 'openssl'
require 'nokogiri'
require 'json'

def aes256_encrypt(password, cleardata)
  key = Digest::SHA256.digest(password)

  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv = cipher.random_iv

  encrypted = cipher.update(cleardata) + cipher.final

  encoded_iv = Base64.strict_encode64(iv)
  encoded_msg = Base64.strict_encode64(encrypted)
  hmac = Base64.strict_encode64(
    OpenSSL::HMAC.digest('sha256', key, encoded_msg)
  )

  "#{encoded_iv}|#{hmac}|#{encoded_msg}"
end

password = ENV['PROTECTOR_PASSWORD'] || "debug"

Dir.glob('_site/posts/*/index.html').each do |post_path|

  puts "========================================"
  puts "Processing #{post_path}"

  html = File.read(post_path)

  doc = Nokogiri::HTML(html)

  content_node = doc.at_css('div.content')

  unless content_node
    puts "div.content NOT FOUND"
    next
  end

  puts "div.content FOUND"

  encrypted = aes256_encrypt(password, content_node.inner_html)

  protected_block = <<~HTML
<div class="content">

<div id="protected"></div>

<div id="decryptModal" class="modal">
  <div class="modal-content">

    <h2>🔒 Protected Post</h2>

    <p>This post is password protected.</p>

    <input id="password" type="password" placeholder="Password">

    <button id="decryptButton">Unlock</button>

    <p id="errmsg" style="color:red"></p>

  </div>
</div>

<script>

const protectedContent = #{encrypted.to_json};

function b64ToBytes(b64){
    return Uint8Array.from(atob(b64), c => c.charCodeAt(0));
}

function bytesToB64(bytes){
    return btoa(String.fromCharCode(...new Uint8Array(bytes)));
}

async function decrypt(){

    const [iv,hmac,cipher] = protectedContent.split("|");

    const password = document.getElementById("password").value;

    const key = await crypto.subtle.digest(
        "SHA-256",
        new TextEncoder().encode(password)
    );

    const hkey = await crypto.subtle.importKey(
        "raw",
        key,
        {name:"HMAC",hash:"SHA-256"},
        false,
        ["sign"]
    );

    const computed = await crypto.subtle.sign(
        "HMAC",
        hkey,
        new TextEncoder().encode(cipher)
    );

    if(bytesToB64(computed).trim() !== hmac.trim()){
        document.getElementById("errmsg").innerHTML = "Wrong password";
        return;
    }

    const aesKey = await crypto.subtle.importKey(
        "raw",
        key,
        {name:"AES-CBC"},
        false,
        ["decrypt"]
    );

    try{

        const plain = await crypto.subtle.decrypt(
            {
                name:"AES-CBC",
                iv:b64ToBytes(iv)
            },
            aesKey,
            b64ToBytes(cipher)
        );

        document.getElementById("protected").innerHTML =
            new TextDecoder().decode(plain);

        document.getElementById("decryptModal").remove();

        if(window.tocbot){
            tocbot.refresh();
        }

    }catch(e){
        document.getElementById("errmsg").innerHTML="Wrong password";
    }

}

document.getElementById("decryptButton").onclick = decrypt;

document.getElementById("password").addEventListener("keyup",e=>{
    if(e.key==="Enter"){
        decrypt();
    }
});

</script>

</div>
HTML

  fragment = Nokogiri::HTML::DocumentFragment.parse(protected_block)

  content_node.replace(fragment)

  File.write(post_path, doc.to_html)

  puts "Protected!"
end