if FORMAT:match 'latex' then
  function RawInline(element)
    -- Superscript formats are added to the Markdown source files as
    -- embedded HTML, so we need a filter to convert these to LaTeX.
    if element.text == "<sup>" then
      return pandoc.RawInline('latex', "\\textsuperscript{")
    elseif element.text == "</sup>" then
      return pandoc.RawInline('latex', "}")
    end

    -- All other RawInline elements are left unmodified
    return element
  end

  function RawBlock(block)
    if (block.format == "html") then
      -- Highlighted text within code blocks (to mark good or bad CHERI
      -- C/C++ examples) are added to the Markdown source files as
      -- embedded HTML, so we need a filter to convert these to LaTeX.
      if (block.text:find('^<pre><code>') ~= nil) then
        
        -- Remove the HTML wrapper tags
        local listing = block.text:gsub("<pre><code>", "")
        listing = listing:gsub("</code></pre>", "")

        -- Clean up inline HTML escaping
        listing = listing:gsub("&lt;", "<")
        listing = listing:gsub("&gt;", ">")

        -- Remove HTML text highlights
        listing = listing:gsub('<mark style="background%-color: #[%a%d]+">', "")
        listing = listing:gsub("</mark>", "")

        -- Remove HTML comment wrappers from LaTeX text highlights
        listing = listing:gsub("<!%-%-{=latex}", "")
        listing = listing:gsub("%-%->", "")

        -- Wrap the code block in a LaTeX code listing environment
        listing = latex_code_listing(listing, true)

        return pandoc.RawBlock('latex', listing)

      -- Pass-through blocks of inline LaTeX. This is effectively the
      -- same as Pandoc's built-in fenced code blocks, but these are
      -- annotated HTML comments instead of code blocks, to make them
      -- invisible to mdBook.
      elseif (block.text:find('^<!%-%-{=latex}') ~= nil) then
        local latexblock = block.text:gsub("^<!%-%-{=latex}", "")
        latexblock = latexblock:gsub("%-%->$", "")
        return pandoc.RawBlock('latex', latexblock)
      end
    end

    -- All other RawBlocks are left unmodified
    return block
  end

  function CodeBlock(block)
    if block.classes:includes("clisting") then
      local numbered = false
      if block.classes:includes("numbered") then
        numbered = true
      end
      local listing = latex_code_listing(block.text, numbered)
      return pandoc.RawBlock('latex', listing)
    elseif block.classes:includes("compilerwarning") then
      local listing = "\\begin{compilerwarning}\n"
      listing = listing .. block.text
      listing = listing .. "\n\\end{compilerwarning}"
      return pandoc.RawBlock('latex', listing)
    end

    -- All other CodeBlocks are left unmodified
    return block
  end
end

-- Helper functions

-- Construct a LaTeX code listing block in a custom style
function latex_code_listing(code, numbered)
  local listing = code
  if (numbered) then
    listing = "\\begin{numberedclisting}\n" .. listing
    listing = listing .. "\\end{numberedclisting}"
  else
    listing = "\\begin{clisting}\n" .. listing
    listing = listing .. "\n\\end{clisting}"
  end

  return listing
end
