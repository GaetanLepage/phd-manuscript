#let minitoc(
  title: none,
  target: heading.where(outlined: true),
  depth: none,
  indent: none,
  fill: repeat([.]),
) = {
  if depth == none { depth = calc.inf }
  context {
    let loc = here()
    let pre = query(
      selector(
        heading.where(outlined: true),
      ).before(loc),
    )
    if pre == () {
      // No previous heading: output full outline from current location
      outline(target: target, title: title, fill: fill, indent: indent)
    } else {
      let after = pre.last()
      let min_level = after.level
      let elems = query(
        selector(
          heading.where(outlined: true),
        ).after(loc),
      )
      let last_elem = none

      for e in elems {
        if e.level <= min_level { break }
        last_elem = e
      }

      let max_level = if depth == calc.inf {
        calc.max(..elems.map(e => e.level))
      } else {
        min_level + depth
      }

      if last_elem == none {
        outline(
          target: selector(target).after(after.location()),
          title: title,
          fill: fill,
          indent: indent,
          depth: max_level,
        )
      } else {
        outline(
          target: selector(target)
            .after(after.location())
            .before(
              last_elem.location(),
            ),
          title: title,
          //fill: fill,
          indent: auto,
          depth: max_level,
        )
      }
    }
  }
}
