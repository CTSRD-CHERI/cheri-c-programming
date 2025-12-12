if FORMAT:match 'latex' then
  --Normalize LaTeX xref names in a lookup table. (mdBook defines the
  --targets by section name but the xrefs by filename, so they don't
  --always match.
  local xreflookup = {
    apis="c-apis-to-get-and-set-capability-properties",
    bitwise_operations="bitwise-operations-on-capability-types",
    capability_faults="capability-related-faults",
    cheriabi="the-cheriabi-posix-process-environment",
    compiler="cheri-compiler-warnings-and-errors",
    recommended_use_c_types="recommended-use-of-c-language-types",
    restrictions_in_capability_locations="restrictions-in-capability-locations-in-memory"
  }

  function Link(link)
    -- URIs are left unmodified
    if link.target:find("^[%a][%a%d+-%.]*:") then
      return link
    end

    local normalized = link.target

    -- All other links are Xrefs to sections, so change them to LaTeX
    -- section references, using the cleveref package.
    if normalized:find("#") then
      -- If there is an hash (e.g. my/xref/file.md#my-heading), we want only
      -- the heading section name (e.g. my-heading).
      normalized = normalized:match("#(.+)$")
    else
      -- 2. If no hash, use your existing logic to clean filenames
      normalized = normalized:gsub("%.%a+$","")
      normalized = normalized:gsub("/$","")
      normalized = normalized:gsub("^%.%./?","")
      normalized = normalized:gsub("^[%a-]+/","")

      -- Apply lookup table ONLY if we are relying on filename matching
      -- (If we used a hash, we assume the hash is the correct ID)
      local lookupkey = normalized:gsub("-","_")
      local lookupvalue = xreflookup[lookupkey]
      if lookupvalue ~= nil then
        normalized = lookupvalue
      end
    end

    --Replace the original Pandoc element with raw LaTeX for the
    --cleveref xref.
    normalized = "\\Cref{sec:" .. normalized
    normalized = normalized .. "}"
    local latexref = pandoc.RawInline('latex', normalized)
    return latexref
  end

  function Header(header)
    --For clarity, prepend LaTeX section labels with "sec:"
    header.identifier = "sec:" .. header.identifier
    return header
  end
end
