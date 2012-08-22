FactoryGirl.define do

  factory :meta_datum_copyright do
    meta_key { MetaKey.find_by_label("copyright status") ||  FactoryGirl.create(:meta_key_copyright_status)} 
    media_resource {FactoryGirl.create :media_resource}
    copyright {FactoryGirl.create :copyright}
  end

end


