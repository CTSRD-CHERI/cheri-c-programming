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

    -- All other links are Xrefs to sections, so change them to LaTeX
    -- section references, using the cleveref package.
    local normalized = link.target:gsub("%.%a+$","")
    normalized = normalized:gsub("/$","")
    normalized = normalized:gsub("^%.%./?","")
    normalized = normalized:gsub("^[%a-]+/","")


    --Apply the lookup table for xrefs that don't match their target
    local lookupkey = normalized:gsub("-","_")
    local lookupvalue = xreflookup[lookupkey]
    if lookupvalue ~= nil then
      normalized = lookupvalue
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
