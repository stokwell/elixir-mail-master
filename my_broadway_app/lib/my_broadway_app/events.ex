defmodule MyBroadwayApp.Events do
  defmodule FinishingCourse do
    defstruct [:user_id]

    def __name__, do: "FinishingCourse"
  end

  defmodule FinishingIntro do
    defstruct [:user_id]

    def __name__, do: "FinishingIntro"
  end

  defmodule FinishingMeditation do
    defstruct [:user_id]

    def __name__, do: "FinishingMeditation"
  end
end
