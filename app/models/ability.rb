class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Campaign

    if user && user.admin?
      can :manage, :all
    elsif user
      can :create, Campaign
    end
  end
end
