-- Read the deck as Markdown so the reading edition has no duplicate manuscript.
-- This filter belongs only to artifacts/talk/read.qmd, beside deck.qmd and assets/.
function Pandoc(doc)
  local path = 'deck.qmd'
  local file = assert(io.open(path, 'r'))
  local deck = pandoc.read(file:read('*a'), 'markdown')
  file:close()
  local blocks = doc.blocks
  blocks:insert(pandoc.Header(2, 'Slide 1 · ' .. pandoc.utils.stringify(deck.meta.title), pandoc.Attr('slide-1')))
  blocks:insert(pandoc.Para(deck.meta.subtitle))
  local number = 1
  for _, block in ipairs(deck.blocks) do
    if block.t == 'Header' and block.level == 2 then
      number = number + 1
      block.content = pandoc.List({pandoc.Str('Slide ' .. number .. ' · ')} ) .. block.content
      block.identifier = 'slide-' .. number
      blocks:insert(block)
    elseif block.t == 'Div' and block.classes:includes('notes') then
      local narrative, support = pandoc.List(), pandoc.List()
      for _, note in ipairs(block.content) do
        local text = pandoc.utils.stringify(note)
        if text ~= 'Narrative:' then
          if text:match('^Support and boundaries:') or text:match('^Optional image alt%-text:') then
            support:insert(note)
          else
            narrative:insert(note)
          end
        end
      end
      blocks:insert(pandoc.Div(narrative, pandoc.Attr('', {'speaker-narrative'})))
      if #support > 0 then
        blocks:insert(pandoc.Div(support, pandoc.Attr('', {'supporting-notes'})))
      end
    else
      blocks:insert(block)
    end
  end
  return pandoc.Pandoc(blocks, doc.meta)
end
