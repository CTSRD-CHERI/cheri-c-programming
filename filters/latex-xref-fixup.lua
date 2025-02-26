function Link(link)
  -- URIs are left unmodified
  if link.target:find("^[%a][%a%d+-%.]*:") then
    return link
  end

  local normalized = link.target:gsub("%.%a+$","")
  normalized = normalized:gsub("/$","")
  normalized = normalized:gsub("^%.%./?","")
  normalized = normalized:gsub("^[%a-]+/","")
  link.target = normalized
  return link
end

