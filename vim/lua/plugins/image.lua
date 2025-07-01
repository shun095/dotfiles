local ffi = require('ffi')
ffi.cdef([[
    typedef struct {
      unsigned short row;
      unsigned short col;
      unsigned short xpixel;
      unsigned short ypixel;
    } winsize;
    int ioctl(int, int, ...);
  ]])
local TIOCGWINSZ = nil
if vim.fn.has("linux") == 1 then
    TIOCGWINSZ = 0x5413
elseif vim.fn.has("mac") == 1 then
    TIOCGWINSZ = 0x40087468
elseif vim.fn.has("bsd") == 1 then
    TIOCGWINSZ = 0x40087468
end

local sz = ffi.new("winsize")
if ffi.C.ioctl(1, TIOCGWINSZ, sz) ~= 0 then
    return {}
else
    return {
        "3rd/image.nvim",
        opts = {}
    }
end
