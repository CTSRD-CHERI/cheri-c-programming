local filenames = {}

function Link(link)
  local path = "src/" .. link.target
  if path ~= "src/cover/README.md" then
    table.insert(filenames, path)
  end
end

function Pandoc(doc)
  return pandoc.Pandoc(pandoc.Para(table.concat(filenames, " ")))
end
