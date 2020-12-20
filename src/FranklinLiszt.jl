module FranklinLiszt
using Franklin
using YAML

FONTAWESOME_DEFAULTCLASS = "fas"

@doc raw"""
    {{dl "file.yaml", "class" "key1, key1:class, key3:class:url, {{...}}"}}

Print a definition list based on the list from `file.yaml` to procude a certain array
of `<span>`s per item in `file.yaml` as one `dl`. the definition title gets the `class`
The entry is treated as an associative array and

* `key1` procudes `<span class="key1`></span>` with the value from `key1:` in that list
* `key2|class` procudes `<span class="class`></span>` with the value from `key2:` in that list
* `key3|class|url3` procudes `<span class="class`></span>` with the value from `key1:`

in that list as a link to the value from `url3:`
you can also specify a sublist within the list of features, which can be a `ol`, `ul` or `dl`.

Note that the file will be loaded and cached, so for multiple uses, no reloading will be required.

# Example
For the file
```yaml
Leonard Euler:
  place: Königsberg
  url: "https://en.wikipedia.org/wiki/Königsberg"
Carl Friedlich Gauß:
  place: Göttingen
  url: "https://en.wikipedia.org/wiki/Göttingen"
```
you could use ``{{dl mathematicians.yaml "name" "place:place:url"}}``
to get
```html
<dl>
<dt class="name">Leonard Euler</dt>
<dd>
    <span class="place">
    <a href="https://en.wikipedia.org/wiki/Königsberg">Königsbreg</a>
    </span>
</dd>
<dt class="name">Carl Friedrich Gauß</dt>
<dd>
    <span class="place">
    <a href="https://en.wikipedia.org/wiki/Göttingen">Göttingen</a>
    </span>
</dd>
</dl>
```
"""
function hfun_dl(params)
    length(params < 3) && error("At least two parameters (file, class, and keys) are required")
    filename = params[1]
    title_class = params[2]
    data = load_yaml(filename)
    keys = split(params[3],",")
    def_list_html = ""
    for title ∈ keys(data)
        list_entry = ""
        for key in keys
            list_entry = """$(list_entry)
                $(format_list_entry(data[title],key))
                """
        end
        list_entries_html = """$(list_entries_html)
            <dt class="$(title_class)">$(title)</dt>
            <dd>
            $(list_entry)
            </dd>
            """
    end
    return """<ul>
            $(format_list_entries(data,keys))
            </ul>"""
end

@doc raw"""
    {{ol "file.yaml", "key1, key1:class, key3:class:url, {{...}}"}}

Print a numbered list based on the list from `file.yaml` to procude a certain set
of `<span>`s per item in `file.yaml` as one `li`.
* `key1` procudes `<span class="key1`></span>` with the value from `key1:` in that list
* `key2|class` procudes `<span class="class`></span>` with the value from `key2:` in that list
* `key3|class|url3` procudes `<span class="class`></span>` with the value from `key1:`
in that list as a link to the value from `url3:`
you can also specify a sublist within the list of features, which can be a `ol`, `ul` or `dl`.

Note that the file will be loaded and cached, so for multiple uses, no reloading will be required.

# Example
For the file
```yaml
- name: Leonard Euler
  place: Königsberg
  url: "https://en.wikipedia.org/wiki/Königsberg"
- name: Carl Friedlich Gauß
  place: Göttingen
  url: "https://en.wikipedia.org/wiki/Göttingen"
```

you could use `{{ol mathematicians.yaml "name, place:place:url"}}`
to get

```html
<ol>
<li>
    <span class="name">Leonard Euler</span>
    <span class="place"><a href="https://en.wikipedia.org/wiki/Königsberg">Königsbreg</a></span
</li>
<li>
    <span class="name">Carl Friedrich Gauß</span>
    <span class="place"><a href="https://en.wikipedia.org/wiki/Göttingen">Göttingen</a></span>
</li>
</ol>
```
"""
function hfun_ol(params)
    length(params < 2) && error("At least two parameters (file and keys) are required")
    filename = params[1]
    data = load_yaml(filename)
    keys = split(params[2],",")
    return """<ol>
        $(format_list_entries(data, keys))
        </ol>"""
end

@doc raw"""
    {{ul "file.yaml", "key1, key1:class, key3:class:url, {{...}}"}}

Print an unnumbered list based on the list from `file.yaml` to procude a certain set
of `<span>`s per item in `file.yaml` as one `li`. Each entry is trated as an associative
array with

* `key1` procudes `<span class="key1`></span>` with the value from `key1:` in that list
* `key2:class` procudes `<span class="class`></span>` with the value from `key2:` in that list
* `key3:class:url3` procudes `<span class="class`></span>` with the value from `key3:`,
    but encapsulated in an url from field `url3`
* `:url4:fas:fa-icon` produces `<span class="url4`></span>` and a link within that,
    but instead of using text, the `fa icon` is used, whose style can be set by the
    middle term (defaults to the free `fas`). Note that this starts with `:` and a default (`fas`) style icon
    can be set using for example `url::fa-book`.
in that list as a link to the value from `url3:`
you can also specify a sublist within the list of features, which can be a `ol`, `ul` or `dl`.

Note that the file will be loaded and cached, so for multiple uses, no reloading will be required.

# Example
For the file
```yaml
- name: Leonard Euler
  place: Königsberg
  url: "https://en.wikipedia.org/wiki/Königsberg"
- name: Carl Friedlich Gauß
  place: Göttingen
  url: "https://en.wikipedia.org/wiki/Göttingen"
```
you could use `{{ul mathematicians.yaml "name, place:place:url"}}`
to get
```html
<ul>
<li>
    <span class="name">Leonard Euler</span>
    <span class="place"><a href="https://en.wikipedia.org/wiki/Königsberg">Königsbreg</a></span
</li>
<li>
    <span class="name">Carl Friedrich Gauß</span>
    <span class="place"><a href="https://en.wikipedia.org/wiki/Göttingen">Göttingen</a></span>
</li>
</ul>
```
"""
function hfun_ul(params)
    length(params < 2) && error("At least two parameters (file and keys) are required")
    filename = params[1]
    data = load_yaml(filename)
    keys = split(params[2],",")
    return """<ul>
        $(format_list_entries(data,keys))
        </ul>"""
end

@doc raw"""
    format_list_entries(data,keys)

Given a set of `keys` and an associative array (or dictionary) produce a list of html
`<span>`s based on [`format_list_entry`](@ref) for every `key`.
"""
function format_list_entries(data,keys)
    list_entry = ""
    for entries ∈ data
        for key in keys
            list_entry = """$(list_entry)
                $(format_list_entry(data,key))
                """
        end

    end
    return """<li>
        $(list_entry)
        </li>"""
end

@doc raw"""
    format_list_entry(data, key)

Given a key that might still contain a formating hint produce an enty.
i.e., the key might be of the form
* `key:class` to produce the span with a certain class
* `key:class:url` to produce the span with a certain class and link to `url`
* `{{ol/ul/dl ...}}` to produce a sublist (calling `hfun_ol`, `hfun_ul` or `hfun_dl` accordingly).
"""
function format_list_entry(data, key)
    list_entry = ""
    if startswith("{{", key)
        key = strip(key, ['{','}'])
        startswith(key, "ol ") && return """
            $(hfun_ol(strip(key[3:end])))
            """
        startswith(key, "ul ") && return """
            $(hfun_ul(strip(key[3:end])))
            """
        startswith(key, "dl ") && return """
            $(hfun_dl(strip(key[3:end])))
            """
    elseif startswith(":",key) # url
        key_parts = split(key[2:end],":")
        return """
                $(format_url(
                    data,
                    first(key_parts);
                    class = first(key_parts),
                    fa_icon = key_parts[3],
                    fa_class = length(key_parts[2]) > 0 ? key_parts[2] : FranklinLiszt.FONTAWESOME_DEFAULTCLASS,
                ))"""
    else #classic key
        key_parts = split(key,":")
        url = length(key_parts) > 3 ? get(data,key_parts[3],"") : ""
        return """
                $(format_entry(
                    data,
                    first(key_parts);
                    class= length(key_parts) > 1 ? key_parts[2] : first(key_parts),
                    url = length(url) > 0 ? url : ""
                ))"""
    end
    return list_entry
end

@doc raw"""
    format_entry(data,key; class=key, url="")

format `data[key]` as html span with class `class` and linked to a nonempty `url`.
"""
function format_entry(data, key; class=key, url="")
    !haskey(data,key) && return "";
    s = data[key]
    (length(url) > 0) && (s = """<a href="$url">$s</a>""")
    return """<span class="$(class)">$s</span>"""
end

@doc raw"""
    format_url(data,url_key; class=url_key, fa_class="fas", fa_icon="")

format `data[url_key]` as html span with class `class` and printed with `fa_icon` 8adding class `fa_class`, too) if nonempty.
"""
function format_url(data, url_key; class=url_key, fa_class=FranklinLiszt.FONTAWESOME_DEFAULTCLASS, fa_icon="")
    !haskey(data,url_key) && return "";
    s = """<i class="$(fa_class) $(fa_icon)"></i>"""
    s = """<a href="$(data[url_key])">$s</a>"""
    return """<span class="$(class)">$s</span>"""
end

@doc raw"""
    load_yaml(file)

Load a ´yaml` file after chekling whether it was already loaded
"""
function load_yaml(file::String)
    if isnothing(Franklin.globvar("liszt_lists"))
        data = YAML.load_file(file)
        Franklin.GLOBAL_VARS["liszt_lists"] = Franklin.dpair(Dict(file=>data))
        return data
    else
        lists = Franklin.globvar("liszt_lists")
        haskey(lists, file) && return listst[file]
        data = YAML.load_file(file)
        push!(lists, file => data)
        Franklin.set_var!(Franklin.GLOBAL_VARS, "liszt_lists", lists)
        return data
    end
end

export hfun_ol, hfun_ul, hfun_dl

end # module
