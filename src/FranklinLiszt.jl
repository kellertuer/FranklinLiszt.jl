module FranklinLiszt
using Franklin
using YAML

"""
{{ol "file.yaml", "key1, key1:class, key3:class:url"}}

Print a numbered list based on the list from `file.yaml` to procude a certain set
of `<span>`s per item in `file.yaml` as one `li`.
* `key1` procudes `<span class="key1`></span>` with the value from `key1:` in that list
* `key2|class` procudes `<span class="class`></span>` with the value from `key2:` in that list
* `key3|class|url3` procudes `<span class="class`></span>` with the value from `key1:`
in that list as a link to the value from `url3:`

Note that the file will be loaded and cached, so for multiple uses, no reloading will be required.

# Example
For the file
```yaml
- name: Leonard Euler
  place: Königsberg
  url: https://en.wikipedia.org/wiki/Königsberg
- name: Carl Friedlich Gauß
  place: Göttingen
  url: https://en.wikipedia.org/wiki/Göttingen
```
you could use {{ol mathematicians.yaml "name, place:place:url"}}
to get
````html
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
˚```
"""
hfun_ol(params)

# similarly ul

# similarly with two fields dd/dt


#
#
# single helplers
"""
Format type
    "key1, key1:class, key3:class:url"
styles
 - report can be `:lazy`, `:warning` or `:error` specifying the action for missing key fields in `entry`-
"""
function hfun_format_yaml_entry(entry::Dict,format; report::Symbol=:lazy)

function load_yaml()
end

end # module
