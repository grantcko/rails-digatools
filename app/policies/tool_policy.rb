class ToolPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end

    def index?
      record.user == user
    end

    def show?
      record.user == user
    end

    def create?
      true
    end

    def update?
      record.user == user
    end

    def destory?
      record.user == user
    end
  end
end
