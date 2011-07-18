# encoding: utf-8
require 'spec_helper'
include Onigiri

describe Onigiri do
  it 'should define "discard_empty_paras" method that removes empty paragraphs from argument string' do
    discard_empty_paras('this is text with <p>some <p></p> emptyness inside</p>').should == 'this is text with <p>some  emptyness inside</p>'
  end

  it 'should define "enclose_block_text" method that encloses any text inside <form>, <blockquote>, <noscript> in <p> tag with trimmed spaces' do
    enclose_block_text('<noscript>hello <form>there <blockquote>pretty</blockquote> world</form></noscript>').gsub(/(\r|\n| )/, '').should == '<noscript><p>hello</p><form><p>there</p><blockquote><p>pretty</p></blockquote><p>world</p></form></noscript>'
  end

  it 'should define "enclose_text" method that encloses any text in <body> using <p> tag' do
    enclose_text('<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>').gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == '<body><p>some text</p><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
  end

  #"drop-proprietary-attributes"=>true, "enclose-text"=>true,
  #"fix-backslash"=>true, "show-body-only"=>"y", "merge-divs"=>"y", "merge-spans"=>"y", "hide-comments"=>true,
  #"char-encoding"=>"utf8", "output-bom" => 'n'
end
