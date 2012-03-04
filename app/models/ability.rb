class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :view, to: :read
    @user = user

    camps
    users
    references
    shelves
    shelf_items
    user_shelves
    posts
    publishers
    misc

    # Licenses
    can :read, License
    can :manage, License if @user and @user.admin?
    can [:edit, :update], License if @user.present?

    # Pages
    can(:read, Page) { |page| page.category.viewable?(user) }
    can(:update, Page) { |page| page.category.editable?(user) }
    can :manage, Page if @user and @user.admin?


    # Categories
    can :read, Category do |category|
      category.viewable?(user)
    end
    can :manage, Category if @user and @user.admin?

    # Colors
    can :manage, Color if @user and @user.admin?

  end

  def publishers
    can :read, Publisher
    can :manage, Publisher if is? :admin
  end

  def camps
    can :manage, Camp if is? :admin
  end

  def users
    can :read, User
    can :new, User unless @user
    can :create, User unless @user
    can :destroy, User if is? :super
    can :update, user { |u| @user.id = u.id or is? :admin }
  end

  def references
    can :manage, Reference if @user
    cannot :destroy, Reference unless is? :admin
  end

  def shelves
    can :read, CampShelf
    can :manage, CampShelf if @user
    cannot :destroy, CampShelf unless @user and @user.admin?
  end

  def shelf_items
    can :manage, ShelfItem do |item|
      can :manage, item.shelf
    end
  end


  def posts
    can :manage, Post if is? :admin
    can :read, Post
  end

  def user_shelves
    can :read, UserShelf
    can :create, UserShelf if @user
    can :update, UserShelf do |shelf|
      @user and shelf.members.include?(@user)
    end
    can :manage, UserShelf do |shelf|
      @user and shelf.user == @user
    end
  end

  def misc
    can :read, Tag
    can :manage, Tagging
    can :read, License
    #can :read, Version
    #can :manage, Version if is? :admin
    can :manage, MediaBite if is? :admin
  end

  def user
    @user
  end

  def is?(rol)
    @user and @user.send("#{rol}?")
  end
end
