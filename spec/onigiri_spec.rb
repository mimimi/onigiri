# encoding: utf-8
require 'spec_helper'
include Onigiri

describe Onigiri do
  it 'should define "drop_empty_paras" method that removes empty paragraphs from argument string' do
    Onigiri::clean('this is text with <p>some </p><p></p> <p>emptyness inside</p>', :drop_empty_paras).should == 'this is text with <p>some </p> <p>emptyness inside</p>'
  end

  it 'should define "enclose_block_text" method that encloses any text inside <form>, <blockquote>, <noscript> in <p> tag with trimmed spaces' do
   Onigiri::clean('<NOSCRIPT>hello <form>there <blockquote>pretty</blockquote> world</form></NOSCRIPT>', :enclose_block_text).gsub(/(\r|\n| )/, '').should == '<noscript><p>hello</p><form><p>there</p><blockquote><p>pretty</p></blockquote><p>world</p></form></noscript>'
  end

  it 'should define "enclose_text" method that encloses any text in <body> using <p> tag' do
   Onigiri::clean('<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>', :enclose_text).gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == '<body><p>some text</p><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
  end

  describe 'should define "fix_backslash" method that fixes "\" for "/" in urls' do
    it 'is fixing href attributes' do
     Onigiri::clean('<a href="http:\\\\google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\">', :fix_backslash).should == '<a href="http://google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http://bing.com/">'
    end

    it 'is fixing src attributes' do
     Onigiri::clean('<img src="http:\\/imagehosting.com/3\\image.png">', :fix_backslash).should == '<img src="http://imagehosting.com/3/image.png">'
    end

    it 'is fixing longdesc attributes' do
     Onigiri::clean('<img src="http://imagehosting.com/3/image.png" longdesc="http:\\/alt.com\\desc.txt">', :fix_backslash).should == '<img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt">'
    end

    it 'is fixing form action attributes' do
     Onigiri::clean('<form action="\\application.php">\\application.php</form>', :fix_backslash).should == '<form action="/application.php">\\application.php</form>'
    end

    it 'should all work together' do
     Onigiri::clean('<a href="http:\\\\google.com/">link</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\"><img src="http://imagehosting.com\\3/image.png" longdesc="http:\\/alt.com\\desc.txt"><form action="\\application.php">русский текст</form>', :fix_backslash).should == '<a href="http://google.com/">link</a><link rel="stylesheet" type="text/css" href="http://bing.com/"><img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt"><form action="/application.php">русский текст</form>'
    end
  end

  it 'should provide a "show_body_only" method that extracts contents of a <body> element for incorporation' do
   Onigiri::clean('<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>', :show_body_only).gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == 'some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div>'
  end

  it 'should throw exception when registering two handlers with the same name' do
    lambda do
      module Onigiri
        register_handler :drop_empty_paras
      end
    end.should raise_error(OnigiriHandlerTaken)
  end

  #"drop-proprietary-attributes"=>true
  #"merge-divs"=>"y", "merge-spans"=>"y", "hide-comments"=>true,
  #"char-encoding"=>"utf8", "output-bom" => 'n'
end
