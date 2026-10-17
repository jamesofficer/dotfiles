local fg, tan = "#000000", "#C49D7B"

local function mode(color)
  return {
    a = { fg = color, bg = "None", gui = "bold" },
    b = { fg = fg, bg = "None" },
    c = { fg = fg, bg = "None" },
  }
end

return {
  normal = mode("#2573B6"),
  insert = mode("#218871"),
  visual = mode("#8D44AC"),
  replace = mode("#D32F2F"),
  command = mode(fg),
  inactive = {
    a = { fg = tan, bg = "None" },
    b = { fg = tan, bg = "None" },
    c = { fg = tan, bg = "None" },
  },
}
