require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body

    assert_match @user.followees.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body

    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test 'should show follow or unfollow button to other user' do
    get user_path(@user)
    assert_not 'div#follow_form'
    assert_not 'div#unfollow_form'

    get user_path(@other_user)
    assert_select 'div#follow_form'
    @user.follow(@other_user)
    get user_path(@other_user)
    assert_select 'div#unfollow_form'
  end
end
