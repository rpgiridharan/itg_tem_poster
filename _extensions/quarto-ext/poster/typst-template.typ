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

  // Footer text.
  // For instance, Name of Conference, Date, Location.
  // or Course Name, Date, Instructor.
  footer_text: "Footer Text",

  // Any URL, like a link to the conference website.
  footer_url: "Footer URL",

  // Email IDs of the authors.
  footer_email_ids: "Email IDs (separated by commas)",

  // Color of the footer (RGB components as decimals)
  footer_color: (red: 51, green: 51, blue: 204),  // Lighter blue (#3333CC)
  
  // Theme color (main color for headers)
  theme_color: (red: 0, green: 51, blue: 153),  // Default darker blue (#003399)

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
  univ_logo_scale: "80",  // Reduced from 100%

  // University logo's column size (in in).
  univ_logo_column_size: "4",  // Reduced from 5

  // Title and authors' column size (in in).
  title_column_size: "18",  // Reduced from 20

  // Poster title's font size (in pt).
  title_font_size: "43",  // Reduced from 48

  // Authors' font size (in pt).
  authors_font_size: "32",  // Reduced from 36

  // Footer's URL and email font size (in pt).
  footer_url_font_size: "27",  // Reduced from 30

  // Footer's text font size (in pt).
  footer_text_font_size: "36",  // Reduced from 40

  // The poster's content.
  body,
) = {
  // Set the body font with 10% smaller size
  set text(font: "STIX Two Text", size: 13pt)  // Reduced from 14pt to 13pt
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
  title_font_size = int(title_font_size) * 0.9pt  // Reduced to 90%
  authors_font_size = int(authors_font_size) * 0.9pt  // Reduced to 90%
  num_columns = int(num_columns)
  footer_url_font_size = int(footer_url_font_size) * 0.9pt  // Reduced to 90%
  footer_text_font_size = int(footer_text_font_size) * 0.9pt  // Reduced to 90%

  // Define the theme color to be consistent across the poster
  let theme_color = if type(theme_color) == dictionary {
    rgb(theme_color.red, theme_color.green, theme_color.blue)
  } else {
    theme_color  // Assume it's already an RGB value
  }
  
  // Define the footer color as a lighter version of theme_color
  let footer_color_rgb = theme_color.lighten(90%)

  // Configure the page.
  // This poster defaults to 36in x 24in.
  set page(
    width: width,
    height: height,
    margin: 
      (top: 2.54cm, left: 2.54cm, right: 2.54cm, bottom: 2.54cm)  // Changed from inches to cm
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings with 10% smaller sizes and white text
  set heading(numbering: none)
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(19pt, weight: 400)  // Reduced from 21pt to 19pt
    if it.level == 1 [
      // First-level headings are centered smallcaps.
      #set align(center)
      #set text({ 26pt })  // Reduced from 29pt to 26pt
      #show: smallcaps
      #v(41pt, weak: true)  // Reduced from 45pt to 41pt
      #block(
        width: 100%,
        fill: theme_color, // Using original theme color (not darkened)
        inset: (x: 12pt, y: 8pt),  // Reduced from 14pt,9pt to 12pt,8pt
        radius: 4pt,  // Reduced from 5pt to 4pt
        [
          #set text(fill: white)  // Set text color to white
          #it.body
        ]
      )
      #v(16pt, weak: true)  // Reduced from 18pt to 16pt
    ] else if it.level == 2 [
      // Second-level headings with width that fits the content
      #set text({ 21pt })  // Reduced from 23pt to 21pt
      #v(26pt, weak: true)  // Reduced from 29pt to 26pt
      #align(left)[
        #box(
          fill: theme_color.lighten(25%), // Lighter theme color
          inset: (x: 10pt, y: 8pt),  // Reduced from 11pt,7pt to 10pt,6pt
          radius: 3pt,  // Reduced from 4pt to 3pt
          [
            #set text(fill: white)  // Set text color to white
            #it.body
          ]
        )
      ]
      #v(12pt, weak: true)  // Reduced from 14pt to 12pt
    ] else if it.level == 3 [
      // Third-level headings with simpler styling
      #set text(size: 16pt, weight: "bold")  // Reduced from 18pt to 16pt
      #v(16pt, weak: true)  // Reduced from 18pt to 16pt
      #it.body
      #v(8pt, weak: true)  // Reduced from 9pt to 8pt
    ] else [
      // Level 4+ headings
      _#(it.body):_
    ]
  })

  // Arranging the title, authors, and department in the header with lab logo overlay
  block(width: 100%, height: auto, {
    // Title and author info in a tinted block with relative positioning for the logo
    align(center, 
      stack(
        {
          // Left logo code removed
        },
        block(
          width: 100%,
          fill: theme_color, // Using original theme color (not darkened)
          radius: 5pt,
          inset: 20pt,
          {
            set text(fill: white)  // Set text color to white
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
  block(width: 100%, height: 100% - 8cm, {  // Reduced from 9cm to 8cm
    // Main content area with fixed height to leave room for footer
    columns(num_columns, gutter: 2em, {  // Reduced from 2em to 2em
      set par(justify: true, first-line-indent: 0em)
      show par: set block(spacing: 0.5em)  // Reduced from 0.6em to 0.5em

      // Display the keywords.
      if keywords != () [
        set text(19pt, weight: 400)  // Reduced from 21pt to 19pt
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
          fill: footer_color_rgb,
          inset: 11pt,  // Reduced from 12pt to 11pt
          radius: 5pt,  // Reduced from 6pt to 5pt
          {
            // Add lab logo to footer if provided
            if lab_logo != "" {
              image(lab_logo, width: int(lab_logo_width) * 0.7cm)  // Reduced from 0.8cm to 0.7cm
              v(0.4em)  // Reduced from 0.5em to 0.4em
            }
            
            // Add footer logos if provided
            let logos = footer_logos.filter(logo => logo != "")
            if logos.len() > 0 {
              grid(
                columns: (auto,) * logos.len(),
                gutter: 16pt,  // Reduced from 18pt to 16pt
                ..logos.map(logo => {
                  image(logo, height: 1.6cm)  // Reduced from 2cm to 1.5cm
                })
              )
            }
          }
        )
      })
    )
  )
}