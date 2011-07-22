This gem is supposed to replace a tidy-ext for one of our projects.

Tidy-ext has nasty memory leaks, tends to crash and is incompatible with Ruby 1.9.
So here I am trying to use a japanese saw to make some rice balls.

What led me here:

```ruby
if (RUBY_VERSION < '1.9')
  begin
    params = {
      "drop-empty-paras"=>true, "drop-proprietary-attributes"=>true, "enclose-block-text"=>true, "enclose-text"=>true,
      "fix-backslash"=>true, "show-body-only"=>"y", "merge-divs"=>"y", "merge-spans"=>"y", "hide-comments"=>true,
      "char-encoding"=>"utf8", "output-bom" => 'n',
      "drop-empty-paras" => 'y'
      }
    tidy = Tidy.open params
    doc = tidy.clean publication.content
  rescue => e
    HoptoadNotifier.notify(
      :error_class   => "Tidy died",
      :error_message => "Tidy error: #{e.message}",
      :parameters    => {:text => publication.content}
    )
    doc = publication.content
  end
else
  doc = publication.content
end
```

PS: Worse is better
