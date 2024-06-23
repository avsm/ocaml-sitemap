(** {1 XML Sitemap Generator}

    This library provides functionality to generate XML sitemaps, which are useful
    for SEO and search engines to better understand the structure of your website.
    For more information on sitemaps, see the {{:https://www.sitemaps.org/protocol.html}Sitemaps protocol}.
*)

type priority = private float
(** The priority of a URL relative to other URLs on the site.
     Valid values range from [0.0] to [1.0]. This value does not affect
     how pages are compared to pages on other sites; it only allows search
     engines to know which pages are more important for the crawlers. *)

val priority : float -> priority
(** [priority p] returns a {!type:priority} value clamped between [0.0] and [1.0]. *)

type changefreq =
  | Always  (** Should be used to describe documents that change each time they are accessed *)
  | Hourly
  | Daily
  | Weekly
  | Monthly
  | Yearly
  | Never (** Should be used to describe archived URLs *)
(** [changefreq] represents how frequently a page is likely to change.
    It provides general information to search engines and may not correlate exactly
    to how often they crawl the page. The value of this tag is considered a hint and not a
    command. Even though search engine crawlers may consider this information when making
    decisions. *)

val changefreq_to_string : changefreq -> string
(** [changefreq_to_string] is the string representation of change frequency according to
    the sitemaps.org XML schema. *)

type lastmod = int * int * int
(** [lastmod] is the date in y/m/d format. This corresponds
    to the {!Ptime.date} type alias. *)

type url = private {
  loc: string; (** URL of the page. This URL must begin with the protocol (such as [http]) and end with a trailing slash, if your web server requires it. This value must be less than 2048 characters. *)
  lastmod: lastmod option; (** If specified, the date must be set to the date the linked page was last modified, not when the sitemap is generated. *)
  changefreq: changefreq option;
  priority: priority option;
}
(** Each URL in the site should have one [url] entry, with optional metadata. Construct these values via {!v}. *)

val v : ?lastmod:lastmod -> ?changefreq:changefreq -> ?priority:priority -> string -> url
(** [v loc] returns a {!url} after performing input validation on the parameters.
    Raises {!Invalid_argument} if the [loc] URL exceeds 2048 characters. *)

val output : url list -> string
(** [output ul] returns an XML string representation of the URLs [ul]. *)

val output_url : Xmlm.output -> url -> unit
(** [output_url o u] outputs a single url [u] to the output [o]. *)

val output_urlset : Xmlm.output -> url list -> unit
(** [output_urlset o ul] outputs a list of URLs [ul] to the output [o]. *)

val output_urlset_to_buffer : Buffer.t -> url list -> unit
(** [output_urlset_to_buffer b ul] appends the URLs [ul] to the buffer [b]. *)
