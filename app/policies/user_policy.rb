class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user.admin? ? scope : scope.none
    end
  end
end
