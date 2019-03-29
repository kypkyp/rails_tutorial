require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @other_user = users(:saber)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select "a", text: "delete", count: 0
  end

  test 'index does not show users unless activated' do
    log_in_as(@non_admin)
    @other_user.activated = false
    @other_user.save
    get users_path
    assert_select 'a[href=?]', user_path(@other_user), count: 0
    @other_user.activated = true
    @other_user.save
    get users_path
    assert_select 'a[href=?]', user_path(@other_user), count: 1
  end

end
