require 'spec_helper' 

describe Normalizers::UriEncodeNormalizer do

  it "returns value if blank" do
    [nil, "", false].each do 
      Normalizers::UriEncodeNormalizer.normalize(nil).should eq(nil)
    end
  end

  it "returns value if not a string" do
    [1, true].each do
      Normalizers::UriEncodeNormalizer.normalize(nil).should eq(nil)
    end
  end
 
  describe "when value is a string" do
    it "returns a valid URI encoded string" do 
      Normalizers::UriEncodeNormalizer.normalize("http://www. givegoods.org").should eq('http://www.%20givegoods.org')
    end
  end
end
