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

  it 'should wrap inline elements with "enclose_text" method' do
    input = '<body><span>some inline text</span><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
    expectation = '<body><p><span>some inline text</span></p><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div></body>'
    Onigiri::clean(input, :enclose_text).gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == expectation
  end

  it 'should work with root element when "enclose_text" method was called on <body>less fragment' do
    input = '<span>some inline text</span><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div>'
    expectation = '<p><span>some inline text</span></p><form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div>'
    Onigiri::clean(input, :enclose_text).gsub(/(\r|\n)/, '').gsub(/> *</, '><').should == expectation
  end

  it 'should work around issue #407 (https://github.com/tenderlove/nokogiri/issues/407)' do
    input = "<p class='red'><span class='capital'>о</span>тветственный редактор легендарного журнала The Strand, на страницах которого впервые увидели свет рассказы Артура Конан Дойля, Эдит Несбит, Агаты Кристи и Редьярда Киплинга\r\n– Эндрю Ф. Гулли обнаружил 15 ранее не публиковавшихся рассказов классика детектива – Дэшила Хэммета.</p>\nСвое открытие Гулли сделал, изучая онлайн-библиотеку и архивы центра Рэнсома при Техасском университете. «Я знал, что Лиллиан Хеллман, бывшая в тесных отношениях с Хэмметом, передала Центру большое количество его бумаг, и надеялся найти среди них что-то интересное, - рассказывает редактор The Strand. – Каково же было мое удивление, когда после тщательной проверки, на которую ушло около 100 часов работы, я обнаружил 15 совершенно новых, неизвестных читателю рассказов»\r\n\r\n<div>\r\n<br/></div>\r\n\r\n<div>Среди рассказов есть как детективы, так и «психологические» истории. Неизвестно, почему автор отказался публиковать их при жизни, ведь, по словам Эндрю Гулли, написаны они идеально: «Некоторые писатели неспособны адекватно оценивать свои произведения: им кажется, что они недоработаны или неталантливо написаны. Возможно, Хэммет тоже так посчитал, потому что, несмотря на отличный слог и композицию, найденные его рассказы отличаются от «традиционных» его произведений. Хотя как раз это и поможет читателям оценитьмногогранность таланта автора».</div>\r\n\r\n<div>\r\n<br/></div>\r\n\r\n<div>Вначале рассказы выйдут в журнале The Strand, а потом будут изданы отдельной книгой. Ранее в The Strand были напечатаны неизвестные произведения других классиков литературы - Марка Твена, П.Дж. Вудхауза, Агаты Кристи и Грэма Грина.</div>"
    pending("Rspec itself leads to `#<NoMethodError: undefined method `call' for #<String>>` error when Onigiri returns string (as it should).\r\nStill useful for testing tho.")
    Onigiri.clean(input, :enclose_text).should_not raise_error
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

  it 'should not do anything with "show_body_only" if there is not body' do
    input = 'some text<form>some text in form</form><p>some text in p</p><div><blockquote>some text in third level element</blockquote></div>'
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
  end

  it 'should provide a "merge_spans" method that replicates "merge_divs" for <span> tag' do
    input = <<HTML
<span class="first">
  <span class="top">
    <span id ="!hoho" class="test">
      <span data-remote="true" style="color: black;" class="tost">
        data
        <span>
          <span class="yopo">
            another text
          </span>
        </span>
      </span>
    </span>
  </span>
</span>
HTML
    expectation = <<HTML
<span class="first top test tost" style="color: black;">
data
<span class="yopo">another text</span>
</span>
HTML
    Onigiri::clean(input, :merge_spans).gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2').should == expectation.gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2')
  end

  it 'should provide "hide_comments" method that will remove all comments from the string' do
    input = <<HTML
<span class="first">
  <span class="top">
    <span id="!hoho" class="test">
    <!------ hello world! -->
      <span data-remote="true" style="color: black;" class="tost">
        data
        <span>
          <span class="yopo">
            another text
          </span>
        </span>
      </span>
    <!-- another comment -->
    </span>
  </span>
</span>
HTML
    expectation = <<HTML
<span class="first">
  <span class="top">
    <span id="!hoho" class="test">
      <span data-remote="true" style="color: black;" class="tost">
        data
        <span>
          <span class="yopo">
            another text
          </span>
        </span>
      </span>
    </span>
  </span>
</span>
HTML
    Onigiri::clean(input, :hide_comments).gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2').should == expectation.gsub(/(\r|\n)/, '').gsub(/> *</, '><').gsub(/(>) +| +(<)/, '\1\2')
  end

  # Noted pending jobs.
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

  it 'should provide "drop-proprietary-attributes" method that will drop all attributes, not defined in W3C standard or applied to mismatched element'
end
