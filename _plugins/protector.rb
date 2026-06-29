require 'base64'
require 'digest'
require 'openssl'
require 'nokogiri'
require 'json'

# -----------------------------
# AES-256-CBC + HMAC
# -----------------------------
def aes256_encrypt(password, cleardata)
  key = Digest::SHA256.digest(password)

  cipher = OpenSSL::Cipher::AES256.new(:CBC)
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv = cipher.random_iv

  encrypted = cipher.update(cleardata) + cipher.final

  encoded_msg = Base64.encode64(encrypted).delete("\n")
  encoded_iv  = Base64.encode64(iv).delete("\n")

  hmac = Base64.encode64(
    OpenSSL::HMAC.digest('sha256', key, encoded_msg)
  ).strip

  "#{encoded_iv}|#{hmac}|#{encoded_msg}"
end

# -----------------------------
# Procesar HTML generado por Jekyll
# -----------------------------
Dir.glob('_site/posts/**/*.html').each do |post_path|

  puts "Procesando: #{post_path}"

  password = ENV['PROTECTOR_PASSWORD'] || "debug"

  html = File.read(post_path)
  doc  = Nokogiri::HTML(html)

  # -----------------------------
  # DETECCIÓN ROBUSTA (FIX NOKOGIRI ERROR)
  # -----------------------------
  is_protected = doc.xpath('//a[contains(@href, "protect")]').any?

  next unless is_protected

  # -----------------------------
  # Buscar contenido del post
  # -----------------------------
  content_node =
    doc.at_css('div.content') ||
    doc.at_css('article') ||
    doc.at_css('main')

  next unless content_node

  # Evitar doble cifrado
  next if html.include?('id="protected"')

  content_to_encrypt = content_node.inner_html

  encrypted = aes256_encrypt(password, content_to_encrypt)
  encrypted_js = encrypted.to_json

  # -----------------------------
  # BLOQUE PROTEGIDO (FRONTEND)
  # -----------------------------
  protected_block = <<~HTML
    <div class="content">
      <div id="protected"></div>

      <!-- Modal -->
      <div id="decryptModal" class="modal">
        <div class="modal-content">
          <div class="lock-icon">🔒</div>
          <h2 class="modal-title" data-toc-skip>This post is locked</h2>
          <p class="explain-text">
            This content is protected. Enter the correct password to unlock it.
          </p>
          <input id="password" type="password" placeholder="Password">
          <button id="decryptButton" class="decrypt-btn">Unlock</button>
          <p id="errmsg" style="color: red; margin-top: 10px;"></p>
        </div>
      </div>

      <script>
        const protectedContent = #{encrypted_js};

        function base64ToBytes(b64) {
          const bin = atob(b64);
          return new Uint8Array([...bin].map(c => c.charCodeAt(0)));
        }

        async function decrypt() {
          const [ivB64, hmacB64, cipherB64] = protectedContent.split("|");
          const password = document.getElementById('password').value;

          const pwKey = await crypto.subtle.digest(
            "SHA-256",
            new TextEncoder().encode(password)
          );

          const keyForHmac = await crypto.subtle.importKey(
            "raw",
            pwKey,
            { name: "HMAC", hash: "SHA-256" },
            false,
            ["sign"]
          );

          const computedHmac = await crypto.subtle.sign(
            "HMAC",
            keyForHmac,
            new TextEncoder().encode(cipherB64)
          );

          const b64 = btoa(String.fromCharCode(...new Uint8Array(computedHmac)));

          if (b64.trim() !== hmacB64.trim()) {
            document.getElementById('errmsg').innerText = "Wrong password";
            return;
          }

          const aesKey = await crypto.subtle.importKey(
            "raw",
            pwKey,
            { name: "AES-CBC" },
            false,
            ["decrypt"]
          );

          const decrypted = await crypto.subtle.decrypt(
            { name: "AES-CBC", iv: base64ToBytes(ivB64) },
            aesKey,
            base64ToBytes(cipherB64)
          );

          const content = new TextDecoder().decode(decrypted);

          document.getElementById('protected').innerHTML = content;

          document.getElementById('decryptModal').style.display = "none";

          if (window.tocbot) {
            tocbot.refresh();
            tocbot.collapseAll();
          }
        }

        document.getElementById("decryptButton").onclick = decrypt;
        document.getElementById("password").addEventListener("keyup", e => {
          if (e.key === "Enter") decrypt();
        });
      </script>
    </div>
  HTML

  fragment = Nokogiri::HTML::DocumentFragment.parse(protected_block)
  content_node.replace(fragment)

  File.write(post_path, doc.to_html)
end