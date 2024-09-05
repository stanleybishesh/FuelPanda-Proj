class Resolvers::Clients::GetAllClients < Resolvers::BaseResolver
  type [ Types::Clients::ClientType ], null: false

  def resolve
    user = current_user
    if user
      ActsAsTenant.with_tenant(user.tenant) do
        Client.all
      end
    else
      raise GraphQL::ExecutionError, "User not logged in"
    end
  end
end