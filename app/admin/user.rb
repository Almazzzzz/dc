ActiveAdmin.register User do
  
  config.batch_actions = false

  permit_params :username, :email, :password, :password_confirmation, 
                :full_edit, :add_admin_role, :remove_admin_role

  includes :profile

  menu parent: 'Users', priority: 0

  scope :all, default: true
  scope :admins
  scope :users
  scope :moderators

  index do
    selectable_column
    id_column
    column 'Avatar' do |user|
      user.profile.avatar? ? image_tag(user.profile.avatar, size: '30') : image_tag('man.png', size: '30')
    end
    column :username
    column :email
    column :profile    
    column :created_at    
    column :current_sign_in_at
    actions
  end

  show do
    tabs do
      tab 'Main data' do
        attributes_table do
          row :id
          row :username
          row :email
          row :encrypted_password
          row :remember_created_at
          row :sign_in_count
          row :current_sign_in_at
          row :last_sign_in_at
          row :current_sign_in_ip
          row :last_sign_in_ip
          row :created_at
          row :updated_at
        end
      end
      tab 'Roles' do
        table_for resource.roles do
          column('Role', :name) 
        end
      end
      tab 'Other' do
        attributes_table do
          row :reset_password_token
          row :reset_password_sent_at
          row :confirmation_token
          row :confirmed_at
          row :confirmation_sent_at
          row :unconfirmed_email
          row :failed_attempts
          row :unlock_token
          row :locked_at
          row :invitation_token
          row :invitation_created_at
          row :invitation_sent_at
          row :invitation_accepted_at
          row :invitation_limit
          row :invited_by_type
          row :invited_by_id
          row :invitations_count
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors
    f.inputs 'User Details' do
      f.input :username
      f.input :email
      if ['edit', 'update'].include? action_name
        f.input :add_admin_role, as: :boolean, label: 'Add admin role' unless object.is_admin? 
        f.input :remove_admin_role, as: :boolean, label: 'Remove admin role' if object.is_admin?
      end
      if ['new', 'create'].include? action_name or params[:full_edit] == 'true'
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

  filter :username
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  sidebar 'User Has', only: [:show, :edit] do
    para strong link_to "User's Profile", admin_profiles_path(q: { user_id_eq: resource.id })
    para strong link_to "User's Posts", admin_user_posts_path(resource)
    para strong link_to "User's Polls", admin_user_polls_path(resource)
    para strong link_to "User's Votes", admin_votes_path(q: { user_id_eq: resource.id })
    para strong link_to "User's Payments", admin_user_payments_path(resource)
    para strong link_to "User's E-mails", admin_user_emails_path(resource)
    para strong link_to "User's Comments", admin_user_comments_path(resource)
    para strong link_to "User's Chat Messages", admin_user_chat_messages_path(resource)
    para strong link_to "User's Roles", admin_user_roles_path(resource)
    para strong link_to "User's Identities", admin_user_identities_path(resource)
  end

  action_item :view, only: [:edit, :show] do
    link_to 'Full Edit', edit_admin_user_path(resource, full_edit: true)
  end

  controller do
    def update
      @user = User.find(params[:id])
      respond_to do |format|
        if @user.update(permitted_params[:user])
          @user.add_role :admin if permitted_params[:user][:add_admin_role] == '1'
          @user.remove_role :admin if permitted_params[:user][:remove_admin_role] == '1'
          format.html { redirect_to admin_user_path(@user), notice: 'User was successfully updated.' }
        else
          format.html { redirect_to edit_admin_user_path(@user), notice: 'Something is went wrong.' }
        end
      end
    end
  end

end
