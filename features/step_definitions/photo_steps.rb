When(/^I create a market with photo$/) do
  find(".add_market_button").click

  within(:css, "#new_market") do
    fill_in "Name",  with: "Dummy Market"
    

    find(:css, "#form-market-photo").set('<div class="control-group attachinary optional market_featured_photo">
      <label class="attachinary optional control-label" for="market_featured_attributes_photo">Photo</label>
      <div class="controls"><input accept="image/jpeg,image/png,image/gif" 
      class="attachinary optional form-control attachinary-input" 
        data-attachinary="{&quot;accessible&quot;:true,&quot;accept&quot;:[&quot;jpg&quot;,&quot;png&quot;,&quot;gif&quot;],&quot;single&quot;:true,&quot;scope&quot;:&quot;photo&quot;,&quot;maximum&quot;:1,&quot;singular&quot;:&quot;photo&quot;,&quot;plural&quot;:&quot;photos&quot;,&quot;files&quot;:[]}" data-form-data="{&quot;timestamp&quot;:1399975085,&quot;callback&quot;:&quot;http://localhost:3000/attachinary/cors&quot;,&quot;tags&quot;:&quot;development_env,attachinary_tmp&quot;,&quot;signature&quot;:&quot;1e4914517bcd8875b7664f07f2f0a3f531ccb286&quot;,&quot;api_key&quot;:&quot;767115286582337&quot;}" data-url="https://api.cloudinary.com/v1_1/espadaysantacruz/auto/upload" id="market_featured_attributes_photo" name="market[featured_attributes][photo]" type="file" disabled=""><div class="attachinary_container" style="display: block;"><input type="hidden" name="market[featured_attributes][photo]" value="[{&quot;public_id&quot;:&quot;fznsjizvey1yjgl1kbn8&quot;,&quot;version&quot;:1399975289,&quot;signature&quot;:&quot;3a294248728758d5b37edca90e869126c48e24fa&quot;,&quot;width&quot;:253,&quot;height&quot;:202,&quot;format&quot;:&quot;jpg&quot;,&quot;resource_type&quot;:&quot;image&quot;,&quot;created_at&quot;:&quot;2014-05-13T10:01:29Z&quot;,&quot;tags&quot;:[&quot;attachinary_tmp&quot;,&quot;development_env&quot;],&quot;bytes&quot;:55021,&quot;type&quot;:&quot;upload&quot;,&quot;etag&quot;:&quot;15a89e78ea28fbeb1dd979e7ee5fcfee&quot;,&quot;url&quot;:&quot;http://res.cloudinary.com/espadaysantacruz/image/upload/v1399975289/fznsjizvey1yjgl1kbn8.jpg&quot;,&quot;secure_url&quot;:&quot;https://res.cloudinary.com/espadaysantacruz/image/upload/v1399975289/fznsjizvey1yjgl1kbn8.jpg&quot;}]"><ul>
    <li><img src="http://res.cloudinary.com/espadaysantacruz/image/upload/c_fill,h_75,w_75/v1399975289/fznsjizvey1yjgl1kbn8.jpg" alt="" width="75" height="75">
      <a href="#" data-remove="fznsjizvey1yjgl1kbn8">Remove</a>
    </li></ul></div></div></div>')
    click_on "Create Market"
  end
end


Then(/^I should see the photo in my media library$/) do
  visit user_photos_path(@user)
  find("img[src*='fznsjizvey1yjgl1kbn8.jpg']")
end
