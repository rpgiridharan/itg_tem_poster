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
  univ_logo: "",  // University logo path
  
  // Lab logo.
  lab_logo: "",  // Changed to empty string default

  // Lab logo width.
  lab_logo_width: "5",  // In cm

  // Left logo (replaces hardcoded lpp-logo.png)
  left_logo: "",  // Add this parameter for the left logo
  
  // Left logo width
  left_logo_width: "5",  // Add this parameter for left logo width

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
  // Tested on 36in x 24in, 48in x 36in, and 48in x 48in posters.
  // For 2-column posters, these may need to be tweaked.
  // See ./examples/example_2_column_18_24.typ for an example.

  // Any keywords or index terms that you want to highlight at the beginning.
  keywords: (),

  // Number of columns in the poster.
  num_columns: "2",

  // University logo's scale (in %).
  univ_logo_scale: "100",

  // University logo's column size (in in).
  univ_logo_column_size: "5",

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
  body,
) = {
  // Set the body font.
  set text(font: "STIX Two Text", size: 16pt)
  let sizes = size.split("x")
  
  let width = 36cm
  let height = 24cm

  // Check if sizes contains two elements
  if sizes.len() == 2 {
    // Check if the elements are valid integers
    let width_str = sizes.at(0)
    let height_str = sizes.at(1)
    
    let is_width_valid = true
    for c in width_str {
      if c.match(regex("[0-9]")) == none {
        is_width_valid = false
      }
    }

    let is_height_valid = true
    for c in height_str {
      if c.match(regex("[0-9]")) == none {
        is_height_valid = false
      }
    }
    
    if is_width_valid and is_height_valid {
      width = int(width_str) * 1cm   // Changed from in to cm
      height = int(height_str) * 1cm  // Changed from in to cm
    }
  }
  
  lab_logo_width = int(lab_logo_width) * 1cm   // Changed from in to cm
  title_font_size = int(title_font_size) * 1pt
  authors_font_size = int(authors_font_size) * 1pt
  num_columns = int(num_columns)
  footer_url_font_size = int(footer_url_font_size) * 1pt
  footer_text_font_size = int(footer_text_font_size) * 1pt

  // Define the theme color to be consistent across the poster
  let theme_color = rgb(footer_color.red, footer_color.green, footer_color.blue)

  // Configure the page.
  // This poster defaults to 36in x 24in.
  set page(
    width: width,
    height: height,
    margin: 
      (top: 3.81cm, left: 3.81cm, right: 3.81cm, bottom: 3.81cm)  // Changed from inches to cm
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: none)
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
      #block(
        width: 100%,
        fill: theme_color,
        inset: (x: 15pt, y: 10pt),
        radius: 5pt,
        [
          #it.body
        ]
      )
      #v(20pt, weak: true)
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      #set text(style: "italic")
      #v(32pt, weak: true)
      #it.body
      #v(10pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      _#(it.body):_
    ]
  })

  // Arranging the title, authors, and department in the header with lab logo overlay
  block(width: 100%, height: auto, {
    // Title and author info in a tinted block with relative positioning for the logo
    align(center, 
      stack(
        {
          // Left logo positioned at the top left corner of the title block
          if left_logo != "" {
            place(
              top + left,
              dx: 10pt,
              dy: 10pt,
              image(left_logo, width: int(left_logo_width) * 1cm)
            )
          }
        },
        block(
          width: 100%,
          fill: theme_color,
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
    )
  })

  // Create a grid with the main content in columns
  block(width: 100%, height: 100% - 10cm, {  // Fixed: replaced calc.subtract with direct subtraction
    // Main content area with fixed height to leave room for footer
    columns(num_columns, gutter: 2em, {
      set par(justify: true, first-line-indent: 0em)
      show par: set block(spacing: 0.65em)

      // Display the keywords.
      if keywords != () [
        set text(24pt, weight: 400)
        show "Keywords": smallcaps
        *Keywords* --- keywords.join(", ")
      ]
      
      // Display the body content
      body
    })
  })

  // Position the footer at the bottom
  place(
    bottom,
    dx: 0%,
    dy: 0%,
    block(
      width: 100%,
      align(center, {
        block(
          width: auto,
          fill: theme_color,
          inset: 12pt,  // Further reduced from 15pt
          radius: 6pt,  // Further reduced radius
          {
            // Add lab logo to footer if provided
            if lab_logo != "" {
              image(lab_logo, width: int(lab_logo_width) * 0.8cm)  // Reduced to 80%
              v(0.5em)  // Further reduced vertical spacing
            }
            
            // Add footer logos if provided
            let logos = footer_logos.filter(logo => logo != "")
            if logos.len() > 0 {
              grid(
                columns: (auto,) * logos.len(),
                gutter: 20pt,  // Further reduced from 25pt
                ..logos.map(logo => image(logo, height: 2cm))  // Reduced to 80% of original 2.5cm
              )
            }
          }
        )
      })
    )
  )
}