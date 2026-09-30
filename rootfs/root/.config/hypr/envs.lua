-- Hyprland environment variables

hl.env("XDG_SESSION_TYPE", "wayland")

local function detect_vm()
  local handle = io.popen("systemd-detect-virt 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and (result:match("qemu") or result:match("kvm") or result:match("vm")) then
      return true
    end
  end
  local f = io.open("/sys/class/dmi/id/product_name", "r")
  if f then
    local product = f:read("*a")
    f:close()
    if product and (product:match("QEMU") or product:match("Standard PC")) then
      return true
    end
  end
  return false
end

if detect_vm() then
  hl.env("LIBGL_ALWAYS_SOFTWARE", "1")
  hl.env("GALLIUM_DRIVER", "llvmpipe")
  hl.env("QSG_RHI_BACKEND", "software")
  hl.env("QT_QUICK_BACKEND", "software")
  hl.env("GSK_RENDERER", "software")
end
