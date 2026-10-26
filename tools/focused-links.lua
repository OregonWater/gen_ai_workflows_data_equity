-- Focused pages stay local; omitted Markdown pages open in the public repository.
-- Read the profile's explicit selection so there is only one target list to maintain.
local root = quarto.project.directory:gsub("\\", "/")
local profile = assert(io.open(root .. "/_quarto-focused.yml", "r"))
local config = pandoc.read("---\n" .. profile:read("*a") .. "\n---\n", "markdown").meta
profile:close()
local selected = {}
for _, target in ipairs(config.project.render) do
  selected[pandoc.utils.stringify(target):gsub("%.%w+$", "")] = true
end
local repository = "https://github.com/OregonWater/gen_ai_workflows_data_equity/blob/main/"

function Link(link)
  local target = link.target
  if target:match("^%a[%w+.-]*:") or target:match("^#") or target:match("^//") then
    return nil
  end
  local path, fragment = target:match("^([^#]+)(.*)$")
  if not path or not (path:match("%.md$") or path:match("%.qmd$") or path:match("%.html$")) then
    return nil
  end
  local input = quarto.doc.input_file:gsub("\\", "/")
  local directory = input:sub(#root + 2):match("^(.*)/") or ""
  local relative = path:sub(1, 1) == "/" and path:sub(2) or directory .. "/" .. path
  local parts = {}
  for part in relative:gmatch("[^/]+") do
    if part == ".." then table.remove(parts)
    elseif part ~= "." then parts[#parts + 1] = part end
  end
  relative = table.concat(parts, "/")
  local stem = relative:gsub("%.%w+$", "")
  if selected[stem] then return nil end
  -- Only redirect real, local Markdown sources; do not rewrite arbitrary HTML links.
  local source = relative
  if source:match("%.html$") then source = stem .. ".md" end
  local file = io.open(root .. "/" .. source, "r")
  if file then
    file:close()
    link.target = repository .. source .. fragment
    return link
  end
end
