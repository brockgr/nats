# Dummy plugin that just tests for one user


class AuthTest

  def authenticate( server, user, pass )
    log("Passed [#{user}] [#{pass}]")
    if (user == "gavin") && (pass == "nivag")
      yield(true)
    else
      yield(false)
    end
  end

end
