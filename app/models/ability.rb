class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Campaign

    if user && user.admin?
      can :manage, :all
      can :set_hashtag, Campaign
    elsif user
      can :create, Campaign
      can :create, SpamReport
    end
  end
end
