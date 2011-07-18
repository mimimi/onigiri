# encoding: utf-8
require 'spec_helper'

describe Onigiri do
  it 'should have discard_empty_paras method that removes empty paragraphs from argument string' do
    discard_empty_paras('this is text with <p>some <p></p> emptyness inside</p>').should == 'this is text with <p>some  emptyness inside</p>'
  end
end
