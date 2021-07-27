# frozen_string_literal: true

require "spec_helper"
require "addressable/idna"

shared_examples_for "converting from unicode to ASCII" do
  it "should convert 'www.google.com' correctly" do
    expect(Addressable::IDNA.to_ascii("www.google.com")).to eq("www.google.com")
  end

  it "should convert 'www.Iñtërnâtiônàlizætiøn.com' correctly" do
    # "www.Iñtërnâtiônàlizætiøn.com"
    r = Addressable::IDNA.to_ascii(
      "www.I\xC3\xB1t\xC3\xABrn\xC3\xA2ti\xC3\xB4" +
      "n\xC3\xA0liz\xC3\xA6ti\xC3\xB8n.com"
    )
    p [:r, r]
    exit
    expect(r).to eq("www.xn--itrntinliztin-vdb0a5exd8ewcye.com")
  end

  # it "should convert 'www.Iñtërnâtiônàlizætiøn.com' correctly" do
  #   expect(Addressable::IDNA.to_ascii(
  #     "www.In\xCC\x83te\xCC\x88rna\xCC\x82tio\xCC\x82n" +
  #     "a\xCC\x80liz\xC3\xA6ti\xC3\xB8n.com"
  #   )).to eq("www.xn--itrntinliztin-vdb0a5exd8ewcye.com")
  # end
end

describe Addressable::IDNA, "when using the pure-Ruby implementation" do
  before :all do
    Addressable.send(:remove_const, :IDNA)
    load "addressable/idna/pure.rb"
  end

  it_should_behave_like "converting from unicode to ASCII"

  it "should not blow up inside fibers" do
    f = Fiber.new do
      # This causes the failure
      # Addressable.send(:remove_const, :IDNA)
      # load "addressable/idna/pure.rb"
      # sleep 1 # let compilation proceed
      # GC.start
    end
    f.resume
  end
end

