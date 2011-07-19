# encoding: utf-8
require 'spec_helper'
include Onigiri

describe Onigiri do
  it 'should define "drop_empty_paras" method that removes empty paragraphs from argument string' do
    drop_empty_paras('this is text with <p>some </p><p></p> <p>emptyness inside</p>').should == 'this is text with <p>some </p> <p>emptyness inside</p>'
  end

  it 'should define "drop_empty_paras" method that removes empty paragraphs from argument Nokogiri::HTML::DocumentFragment' do
    drop_empty_paras(Nokogiri::HTML::DocumentFragment.parse 'this is text with <p>some </p><p></p> <p>emptyness inside</p>').should == 'this is text with <p>some </p> <p>emptyness inside</p>'
  end

  it 'should define "enclose_block_text" method that encloses any text inside <form>, <blockquote>, <noscript> in <p> tag with trimmed spaces' do
    enclose_block_text('<NOSCRIPT>hello <form>there <blockquote>pretty</blockquote> world</form></NOSCRIPT>').gsub(/(\r|\n| )/, '').should == '<noscript><p>hello</p><form><p>there</p><blockquote><p>pretty</p></blockquote><p>world</p></form></noscript>'
  end

  it 'should define "enclose_block_text" method that encloses any text inside <form>, <blockquote>, <noscript> in <p> tag with trimmed spaces (Nokogiri::HTML::DocumentFragment)' do
    enclose_block_text(Nokogiri::HTML::DocumentFragment.parse '<noscript>hello <form>there <blockquote>pretty</blockquote> world</form></noscript>').gsub(/(\r|\n| )/, '').should == '<noscript><p>hello</p><form><p>there</p><blockquote><p>pretty</p></blockquote><p>world</p></form></noscript>'
  end

  it 'should define "enclose_text" method that encloses any text in <body> using <p> tag' do
    enclose_text('<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>').gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == '<body><p>some text</p><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
  end

  it 'should define "enclose_text" method that encloses any text in <body> using <p> tag (Nokogiri::HTML::DocumentFragment)' do
    enclose_text(Nokogiri::HTML::DocumentFragment.parse '<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>').gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == '<body><p>some text</p><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
  end

  describe 'should define "fix_backslash" method that fixes "\" for "/" in urls' do
    it 'is fixing href attributes' do
      fix_backslash('<a href="http:\\\\google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\">').should == '<a href="http://google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http://bing.com/">'
    end

    it 'is fixing src attributes' do
      fix_backslash('<img src="http:\\/imagehosting.com/3\\image.png">').should == '<img src="http://imagehosting.com/3/image.png">'
    end

    it 'is fixing longdesc attributes' do
      fix_backslash('<img src="http://imagehosting.com/3/image.png" longdesc="http:\\/alt.com\\desc.txt">').should == '<img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt">'
    end

    it 'is fixing form action attributes' do
      fix_backslash('<form action="\\application.php">\\application.php</form>').should == '<form action="/application.php">\\application.php</form>'
    end

    it 'should all work together' do
      fix_backslash('<a href="http:\\\\google.com/">link</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\"><img src="http://imagehosting.com\\3/image.png" longdesc="http:\\/alt.com\\desc.txt"><form action="\\application.php">русский текст</form>').should == '<a href="http://google.com/">link</a><link rel="stylesheet" type="text/css" href="http://bing.com/"><img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt"><form action="/application.php">русский текст</form>'
    end

    it 'is fixing href attributes (Nokogiri::HTML::DocumentFragment)' do
      fix_backslash(Nokogiri::HTML::DocumentFragment.parse '<a href="http:\\\\google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\">').should == '<a href="http://google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http://bing.com/">'
    end

    it 'is fixing src attributes (Nokogiri::HTML::DocumentFragment)' do
      fix_backslash(Nokogiri::HTML::DocumentFragment.parse '<img src="http:\\/imagehosting.com/3\\image.png">').should == '<img src="http://imagehosting.com/3/image.png">'
    end

    it 'is fixing longdesc attributes (Nokogiri::HTML::DocumentFragment)' do
      fix_backslash(Nokogiri::HTML::DocumentFragment.parse '<img src="http://imagehosting.com/3/image.png" longdesc="http:\\/alt.com\\desc.txt">').should == '<img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt">'
    end

    it 'is fixing form action attributes (Nokogiri::HTML::DocumentFragment)' do
      fix_backslash(Nokogiri::HTML::DocumentFragment.parse '<form action="\\application.php">\\application.php</form>').should == '<form action="/application.php">\\application.php</form>'
    end

    it 'should all work together (Nokogiri::HTML::DocumentFragment)' do
      fix_backslash(Nokogiri::HTML::DocumentFragment.parse '<a href="http:\\\\google.com/">link</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\"><img src="http://imagehosting.com\\3/image.png" longdesc="http:\\/alt.com\\desc.txt"><form action="\\application.php">русский текст</form>').should == '<a href="http://google.com/">link</a><link rel="stylesheet" type="text/css" href="http://bing.com/"><img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt"><form action="/application.php">русский текст</form>'
    end
  end

  it 'should provide a "show_body_only" method that extracts contents of a <body> element for incorporation' do
    show_body_only('<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>').gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == 'some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div>'
  end

  #"drop-proprietary-attributes"=>true
  #"show-body-only"=>"y", "merge-divs"=>"y", "merge-spans"=>"y", "hide-comments"=>true,
  #"char-encoding"=>"utf8", "output-bom" => 'n'
end
