type priority = float
let priority f = min 1.0 (max 0.0 f)

type changefreq =
  | Always
  | Hourly
  | Daily
  | Weekly
  | Monthly
  | Yearly
  | Never

let changefreq_to_string = function
  | Always -> "always"
  | Hourly -> "hourly"
  | Daily -> "daily"
  | Weekly -> "weekly"
  | Monthly -> "monthly"
  | Yearly -> "yearly"
  | Never -> "never"

type lastmod = int * int * int

type url = {
  loc: string;
  lastmod: (int * int * int) option; (* Ptime.date option *)
  changefreq: changefreq option;
  priority: priority option;
}

let v ?lastmod ?changefreq ?priority loc =
  if String.length loc >= 2048 then
    raise (Invalid_argument "location value must be less than 2048 characters");
  { loc; lastmod; changefreq; priority }

let lastmod_to_string (y,m,d) = Printf.sprintf "%04d-%02d-%02d" y m d

let priority_to_string p = Printf.sprintf "%1.1f" p

let tag ?(attr=[]) n = ("", n), attr

let output_url o u =
  let otag t s = Xmlm.output o (`El_start (tag t)); Xmlm.output o (`Data s); Xmlm.output o `El_end in
  let opttag tag fn s = match s with None -> () | Some s -> otag tag (fn s) in
  Xmlm.output o (`El_start (tag "url"));
  otag "loc" u.loc;
  opttag "lastmod" lastmod_to_string u.lastmod;
  opttag "changefreq" changefreq_to_string u.changefreq;
  opttag "priority" priority_to_string u.priority;  
  Xmlm.output o `El_end

let output_urlset o urls =
  Xmlm.output o (`Dtd None);
  Xmlm.output o (`El_start (tag ~attr:[("","xmlns"),"http://www.sitemaps.org/schemas/sitemap/0.9"] "urlset"));
  List.iter (output_url o) urls;
  Xmlm.output o `El_end

let output_urlset_to_buffer b urls =
  let o = Xmlm.make_output ~nl:true (`Buffer b) in
  output_urlset o urls

let output urls =
  let b = Buffer.create 1024 in
  output_urlset_to_buffer b urls;
  Buffer.contents b
