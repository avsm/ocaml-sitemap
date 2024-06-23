(lang dune 3.14)
(name sitemap)
(maintainers "Anil Madhavapeddy <anil@recoil.org>")
(source (github avsm/ocaml-sitemap))
(package
 (name sitemap)
 (synopsis "Generate XML sitemaps")
 (description "This project is an OCaml tool to generate XML sitemaps, useful for SEO and search engines.")
 (depends
  (ocaml (>= 4.14))
  (xmlm (>= 1.2.0))
  (ptime :with-doc)))
(generate_opam_files true)
