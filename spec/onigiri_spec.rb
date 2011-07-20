# encoding: utf-8
require 'spec_helper'
include Onigiri

describe Onigiri do
  it 'should throw exception when registering two handlers with the same name' do
    lambda do
      module Onigiri
        register_handler :drop_empty_paras
      end
    end.should raise_error(OnigiriHandlerTaken)
  end

  it 'should define "drop_empty_paras" method that removes empty paragraphs from argument string' do
    input = 'this is text with <p>some </p><p></p> <p>emptyness inside</p>'
    expectation = 'this is text with <p>some </p><p>emptyness inside</p>'
    Onigiri::clean(input, :drop_empty_paras).should == expectation
  end

  it 'should define "enclose_block_text" method that encloses any text inside <form>, <blockquote>, <noscript> in <p> tag with trimmed spaces' do
    input = '<NOSCRIPT>hello <form>there <blockquote>pretty</blockquote> world</form></NOSCRIPT>'
    expectation = '<noscript><p>hello</p><form><p>there</p><blockquote><p>pretty</p></blockquote><p>world</p></form></noscript>'
    Onigiri::clean(input, :enclose_block_text).gsub(/(\r|\n| )/, '').should == expectation
  end

  it 'should define "enclose_text" method that encloses any text in <body> using <p> tag' do
    input = '<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
    expectation = '<body><p>some text</p><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
    Onigiri::clean(input, :enclose_text).gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == expectation
  end

  describe 'should define "fix_backslash" method that fixes "\" for "/" in urls' do
    it 'is fixing href attributes' do
      input = '<a href="http:\\\\google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\">'
      expectation = '<a href="http://google.com/">http:\\\\google.com/</a><link rel="stylesheet" type="text/css" href="http://bing.com/">'
      Onigiri::clean(input, :fix_backslash).should == expectation
    end

    it 'is fixing src attributes' do
      input = '<img src="http:\\/imagehosting.com/3\\image.png">'
      expectation = '<img src="http://imagehosting.com/3/image.png">'
      Onigiri::clean(input, :fix_backslash).should == expectation
    end

    it 'is fixing longdesc attributes' do
      input = '<img src="http://imagehosting.com/3/image.png" longdesc="http:\\/alt.com\\desc.txt">'
      expectation = '<img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt">'
      Onigiri::clean(input, :fix_backslash).should == expectation
    end

    it 'is fixing form action attributes' do
      input = '<form action="\\application.php">\\application.php</form>'
      expectation = '<form action="/application.php">\\application.php</form>'
      Onigiri::clean(input, :fix_backslash).should == expectation
    end

    it 'should all work together' do
      input = '<a href="http:\\\\google.com/">link</a><link rel="stylesheet" type="text/css" href="http:\\\\bing.com\\"><img src="http://imagehosting.com\\3/image.png" longdesc="http:\\/alt.com\\desc.txt"><form action="\\application.php">русский текст</form>'
      expectation = '<a href="http://google.com/">link</a><link rel="stylesheet" type="text/css" href="http://bing.com/"><img src="http://imagehosting.com/3/image.png" longdesc="http://alt.com/desc.txt"><form action="/application.php">русский текст</form>'
      Onigiri::clean(input, :fix_backslash).should == expectation
    end
  end

  it 'should provide a "show_body_only" method that extracts contents of a <body> element for incorporation' do
    input = '<body>some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
    expectation = 'some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div>'
    Onigiri::clean(input, :show_body_only).gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == expectation
  end

  it 'should provide a "merge_divs" method that will merge nested <div> such as "<div><div>...</div></div>" into top-level div discarding inner <div>s attributes except for "class" and "style"' do
    input = <<HTML
<div class="first">
  <div class="top">
    <div id ="!hoho" class="test">
      <div data-remote="true" style="color: black;" class="tost">
        <p>data</p>
        <div>
          <div class="yopo">
            another text
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
HTML
    expectation = <<HTML
<div class="first top test tost" style="color: black;">
<p>data</p>
<div class="yopo">another text</div>
</div>
HTML
    Onigiri::clean(input, :merge_divs).gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2').should == expectation.gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2')
    Onigiri::clean(input, :merge_divs).gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2').should == expectation.gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2')
  end

  it 'should provide a "automerge_divs" method that will merge nested <div> such as "<div><div>...</div></div>" into top-level div moving inner <div>s attributes into outer one; however it shouldnt merge together <div>s that have valid id attributes (id attribute serves as a down-top merge breakpoint)' do
    input = <<HTML
<div class="first">
  <div class="top" id="fff">
    <div id ="!hoho" class="test">
      <div data-remote="true" style="color: black;" class="tost">
        <p>data</p>
        <div>
          <div id="yopo">
            another text
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
HTML
    expectation = <<HTML
<div class="first top" id="fff">
<div id="!hoho" class="test tost c1" data-remote="true">
<p>data</p>
<div id="yopo">another text</div>
</div>
</div>
HTML
    pending('Noted the difference between merge-divs: yes/auto, but the latter one doesn\'t get priority')
  end

  #"drop-proprietary-attributes"=>true
  #"merge-divs"=>"y", "merge-spans"=>"y", "hide-comments"=>true,
  #"char-encoding"=>"utf8", "output-bom" => 'n'
end
