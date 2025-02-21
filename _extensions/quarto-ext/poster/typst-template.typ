#let poster(
  // The poster's size.
  size: "'36x24' or '48x36''",

  // The poster's title.
  title: "Paper Title",

  // A string of author names.
  poster-authors: "",  // Changed default to empty string

  // Department name.
  departments: "Department Name",

  // University logo.
  lab_logo: "",  // Changed to empty string default

  // Footer text.
  // For instance, Name of Conference, Date, Location.
  // or Course Name, Date, Instructor.
  footer_text: "Footer Text",

  // Any URL, like a link to the conference website.
  footer_url: "Footer URL",

  // Email IDs of the authors.
  footer_email_ids: "Email IDs (separated by commas)",

  // Color of the footer (RGB components as decimals)
  footer_color: (red: 232, green: 240, blue: 254),  // e8f0fe in RGB

  // Additional logos to display in footer
  footer_logos: (),  // Empty default, will be filled by Quarto

  // DEFAULTS
  // ========
  // For 3-column posters, these are generally good defaults.
  // Tested on 36in x 24in, 48in x 36in, and 36in x 48in posters.
  // For 2-column posters, you may need to tweak these values.
  // See ./examples/example_2_column_18_24.typ for an example.

  // Any keywords or index terms that you want to highlight at the beginning.
  keywords: (),

  // Number of columns in the poster.
  num_columns: "2",

  // University logo's width (in cm).
  lab_logo_width: "5",  // Changed from inches to cm

  // Title and authors' column size (in in).
  title_column_size: "20",

  // Poster title's font size (in pt).
  title_font_size: "48",

  // Authors' font size (in pt).
  authors_font_size: "36",

  // Footer's URL and email font size (in pt).
  footer_url_font_size: "30",

  // Footer's text font size (in pt).
  footer_text_font_size: "40",

  // The poster's content.
  body
) = {
  // Set the body font.
  set text(font: "STIX Two Text", size: 16pt)
  let sizes = size.split("x")
  let width = int(sizes.at(0)) * 1cm   // Changed from in to cm
  let height = int(sizes.at(1)) * 1cm   // Changed from in to cm
  lab_logo_width = int(lab_logo_width) * 1cm   // Changed from in to cm
  title_font_size = int(title_font_size) * 1pt
  authors_font_size = int(authors_font_size) * 1pt
  num_columns = int(num_columns)
  footer_url_font_size = int(footer_url_font_size) * 1pt
  footer_text_font_size = int(footer_text_font_size) * 1pt

  // Configure the page.
  // This poster defaults to 36in x 24in.
  set page(
    width: width,
    height: height,
    margin: 
      (top: 2.54cm, left: 5.08cm, right: 5.08cm, bottom: 5.08cm)  // Changed from inches to cm
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "I.A.1.")
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(24pt, weight: 400)
    if it.level == 1 [
      // First-level headings are centered smallcaps.
      #set align(center)
      #set text({ 32pt })
      #show: smallcaps
      #v(50pt, weak: true)
      #if it.numbering != none {
        numbering("I.", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(35.75pt, weak: true)
      #line(length: 100%)
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      #set text(style: "italic")
      #v(32pt, weak: true)
      #if it.numbering != none {
        numbering("i.", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(10pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        numbering("1)", deepest)
        [ ]
      }
      _#(it.body):_
    ]
  })

  // Arranging the logo, title, authors, and department in the header.
  block(width: 100%, height: auto, {
    // Only show logo if path is provided
    if lab_logo != "" {
      align(center, image(lab_logo, width: lab_logo_width))
      v(2em)  // Space between logo and title block
    }
    
    // Then the title and author info in a tinted block
    align(center, 
      block(
        width: 100%,
        fill: rgb(232, 240, 254),  // e8f0fe in RGB integers
        radius: 5pt,
        inset: 20pt,
        {
          text(title_font_size, title)
          linebreak()
          v(0.5em)
          if poster-authors != "" [
            #text(authors_font_size, emph(poster-authors))
            #linebreak()
          ]
          text(authors_font_size * 0.8, departments) 
        }
      )
    )
  })

  // Create a grid with the main content in columns and footer in full width
  grid(
    rows: (auto, auto),
    row-gutter: 2em,
    [
      // Main content area in columns
      #show: columns.with(num_columns, gutter: 64pt)
      #set par(justify: true, first-line-indent: 0em)
      #show par: set block(spacing: 0.65em)

      // Display the keywords.
      #if keywords != () [
          #set text(24pt, weight: 400)
          #show "Keywords": smallcaps
          *Keywords* --- #keywords.join(", ")
      ]

      // Display the poster's contents.
      #body
    ],
    [
      // Footer area
      #if footer_logos != () {
        align(center, {
          let logos = footer_logos.filter(logo => logo != "")
          if logos.len() > 0 {
            block(
              width: 100%,
              fill: rgb(footer_color.red, footer_color.green, footer_color.blue),
              inset: 20pt,
              radius: 10pt,
              {
                grid(
                  columns: (auto,) * logos.len(),
                  gutter: 30pt,
                  ..logos.map(logo => image(logo, height: 2.5cm))
                )
              }
            )
          }
        })
      }
    ]
  )
}