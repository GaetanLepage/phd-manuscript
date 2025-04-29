#import "matter_functions.typ": front-matter, main-matter, back-matter

#let fill-line(left-text, right-text) = [#left-text #h(1fr) #right-text]

// Changes the figure placement across the entire document
#let fig-placement = top

// The `in-outline` mechanism is for showing a short caption in the list of figures
// See https://sitandr.github.io/typst-examples-book/book/snippets/chapters/outlines.html#long-and-short-captions-for-the-outline
#let in-outline = state("in-outline", false)

// This function gets your whole document as its `body` and formats it
#let template(
  // The title for your work.
  title: [Your Title],
  // Author's name.
  author: "Author",
  // The paper size to use.
  paper-size: "a4",
  // Date that will be displayed on cover page.
  // The value needs to be of the 'datetime' type.
  // More info: https://typst.app/docs/reference/foundations/datetime/
  // Example: datetime(year: 2024, month: 03, day: 17)
  date: none,
  // Format in which the date will be displayed on cover page.
  // More info: https://typst.app/docs/reference/foundations/datetime/#format
  date-format: "[month repr:long] [day padding:zero], [year repr:full]",
  // Add outlines to the Table of content
  include-outlines-in-contents: true,
  // Boxes around refs
  boxed-refs: false,
  // The content of your work.
  body,
) = {
  // Set the document's metadata.
  set document(
    title: title,
    author: author,
    date: if date != none { date } else { auto },
  )

  // Set the body font. (needs to be installed manually: let's use the default one)
  set text(
    font: ("Utopia LaTeX"),
    size: 12pt
  )

  // Configure page size and margins.
  let margin = 2.5cm
  set page(
    paper: paper-size,
    margin: margin,
    numbering: "1",
    number-align: right,
  )
  let outside-margin = margin

  /* -------------------------------------------------------------------- */
  /* REFERENCES */
  // Color boxes around ref links
  let enable-boxed-refs = boxed-refs not in (none, false)
  let box-color = if type(boxed-refs) == color {
    boxed-refs
  }
  else {
    green
  }
  show ref: it => {
    if not enable-boxed-refs {
      return it
    }
    // Skip bibliography citations.
    if it.element == none {
      return it
    }
    box(
      stroke: 1pt + box-color,
      outset: (bottom: 1.5pt, rest: .5pt),
      it
    )
  }

  /* -------------------------------------------------------------------- */
  /* PARAGRAPHS */
  
  // Configure paragraph properties.
  // Default leading is 0.65em.
  set par(
    //leading: 0.7em,
    justify: true,
    linebreaks: "optimized"
  )
  // Default spacing is 1.2em.
  set par(spacing: 1.35em)

  /* -------------------------------------------------------------------- */
  /* URL */
  show link: underline
  show link: set text(blue)
  
  // Show a small maroon circle next to external links.
  //show link: it => {
  //  // Workaround for ctheorems package so that its labels keep the default link styling.
  //  if type(it.dest) == label { return it }
  //  it
  //  h(1.6pt)
  //  super(
  //    box(height: 3.8pt, circle(radius: 1.2pt, stroke: 0.7pt + rgb("#993333"))),
  //  )
  //}

  /* -------------------------------------------------------------------- */
  /* TITLES */
  show heading: it => {
    v(2.5em, weak: true)
    it
    v(1.5em, weak: true)
  }

  // Style chapter headings.
  show heading.where(level: 1): set heading(
    supplement: [Chapter]
  )
  show heading.where(level: 1): it => {
    //set text(size: 22pt)
    
    //let black_rectangle = place(
    //  //dx: -page.margin.outside,
    //  dx: -outside-margin,
    //  dy: -1em,
    //  rect(
    //    fill: black,
    //    width: outside-margin - 5pt,
    //    //width: outside-margin + 50pt,
    //    height: 2em
    //  ),
    //)

    let heading_number = if heading.numbering == none {
      []
    } else {
      counter(heading.where(level: 1)).display()
    }
    //let white_heading_number = place(
    //  dx: -1em,
    //  text(
    //    fill: white,
    //    heading_number,
    //    //[#it.supplement #heading_number]
    //  )
    //)

    // Start chapters on even pages
    /*
      FIXME: `pagebreak(to: "even")` replicates the behaviour seen in the
      original template, except for an important detail: the resulting empty
      pages still show the header and page number. This is not great and is the
      subject of https://github.com/typst/typst/issues/2722.
    */
    //pagebreak(to: "even")
    pagebreak()

    if it.numbering != none {
      set text(size: 36pt)
      [Chapter]
      h(0.5em)
      text(
        heading_number,
        fill: maroon,
        size: 58pt,
        weight: "bold"
      )
      h(0.5em)
    }
  
    v(0em)
    text(
      it.body,
      size: 36pt,
      weight: "light"
    )
    v(-1em)
    //v(1em)


    //v(16%)
    //set text(size: 36pt)
    //rect(
    //  stroke: none,
    //  inset: 0em,
    //  black_rectangle + white_heading_number + it.body,
    //  //[ \ #it.body ],
    //)
    
    // Has no effect, still shows "Section"
    //set heading(supplement: [Chapter])
  }

  // Configure heading numbering.
  set heading(numbering: "1.1")

  // Do not hyphenate headings.
  show heading: set text(hyphenate: false)

  // Set page header
  set page(
    header-ascent: 30%, header: context{
      // Get current page number.
      let page-number = here().page()

      // [ #repr(query(<disable_header>).map(el => el.location().page()).slice(0, 5)) ]
      // If the current page is the start of a chapter, don't show a header
      let target = heading.where(level: 1)
      if query(target).any(it => it.location().page() == page-number) {
        // return [New chapter! page #here().page(), #i]
        return []
      }

      // Find the chapter of the section we are currently in.
      let before = query(target.before(here()))
      if before.len() > 0 {
        let current = before.last()

        let chapter-title = current.body
        let chapter-number = counter(heading.where(level: 1)).display()
        let chapter-number-text = [#current.supplement #chapter-number]
        //let chapter-number-text = [Chapter #chapter-number]

        if current.numbering != none {
          let (left-text, right-text) = if calc.odd(page-number) {
            (chapter-number-text, chapter-title)
          } else {
            (chapter-title, chapter-number-text)
          }
          text(weight: "bold", fill-line(left-text, right-text))
          v(-1em)
          line(length: 100%, stroke: 0.5pt)
        }
      }
    },
  )
  
  /* -------------------------------------------------------------------- */
  /* OUTLINES */

  // The `in-outline` is for showing a short caption in the list of figures
  // See https://sitandr.github.io/typst-examples-book/book/snippets/chapters/outlines.html#long-and-short-captions-for-the-outline
  show outline: it => {
    in-outline.update(true)
    // Show table of contents, list of figures, list of tables, etc. in the table of contents
    
    set heading(outlined: include-outlines-in-contents)
    
    // This hides the citation in outlines (mostly for the table of figures)
    show cite: none
    
    it
    in-outline.update(false)
  }

  // Hide the '...' filling for top-level entried (chapters)
  show outline.entry.where(level: 1): set outline.entry(fill: none)

  show outline.entry: it => {
    // Only apply styling if we're in the table of contents (not list of figures or list of tables, etc.)
    if it.element.func() == heading {
      if it.level == 1 {
        v(2em, weak: true)
        strong(it)
      } else {
        it
      }
    } else {
      it
    }
  }

  // @GL: Configure equation numbering.
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }
  set math.equation(
    numbering: eq_num => {
      let chap_num =  counter(heading).get().first()
      numbering(
        "(1.1)",
        chap_num,
        eq_num
      )
    }
  )

  /* @GL: Do not align equations to the left
  show math.equation.where(block: true): it => {
    set align(left)
    // Indent
    pad(left: 2em, it)
  }
  */

  // FIXME: Has no effect?
  set place(clearance: 2em)
  
  /* -------------------------------------------------------------------- */
  /* FIGURES */

  set figure(
    numbering: fig_num => {
      let chap_num =  counter(heading).get().first()
      numbering(
        "1.1",
        chap_num,
        fig_num
      )
    },
    gap: 1.5em
  )

  set figure.caption(
    separator: [ -- ],
  )

  // @GL: Let's have all captions centered
  //show figure.caption: it =>{
  //  if it.kind == table {
  //    align(center, it)
  //  } else {
  //    align(left, it)
  //  }
  //}
  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    // Break large tables across pages.
    set block(breakable: true)
    it
  }
  // @GL: prevent figures from being split accross several pages
  show figure: set block(breakable: false)
  set figure(placement: fig-placement)
  
  // @GL: Do not remove strokes from table
  //set table(stroke: none)

  /* -------------------------------------------------------------------- */
  /* RAW (code) */
  
  // Set raw text font.
  show raw: set text(
    font: ("Iosevka", "Fira Mono"),
    size: 9pt
  )

  // Display inline code in a small box that retains the correct baseline.
  // show raw.where(block: false): box.with(
  //   fill: luma(250).darken(2%), inset: (x: 3pt, y: 0pt), outset: (y: 3pt), radius: 2pt,
  // )

  // Display block code with padding.
  show raw.where(block: true): block.with(inset: (x: 5pt))


  body
}