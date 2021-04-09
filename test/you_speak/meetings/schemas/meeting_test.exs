defmodule YouSpeak.Meetings.Schemas.MeetingTest do
  use YouSpeak.DataCase

  alias YouSpeak.Factory
  alias YouSpeak.Meetings.Schemas.Meeting

  def meeting_factory(attributes \\ %{}), do: Factory.build(:meeting, attributes)

  test "return valid true when data is valid" do
    changeset =
      meeting_factory()
      |> Meeting.changeset(%{})

    assert changeset.valid?
  end

  describe "validations" do
    test "name must not be blank" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{name: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name must not be nil" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{name: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name must not be higher than 200 chars" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{name: String.duplicate("a", 201)})

      refute changeset.valid?
      assert "should be at most 200 character(s)" in errors_on(changeset).name
    end
  end

  describe "video_url" do
    test "video_url must not be blank" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).video_url
    end

    test "video_url must not be nil" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).video_url
    end

    test "video_url must invalid without an scheme" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: "invalid"})

      refute changeset.valid?
      assert "is missing a scheme (e.g. https)" in errors_on(changeset).video_url
    end

    test "video_url must invalid without a host" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: "http://.com.br"})

      refute changeset.valid?
      assert "invalid host" in errors_on(changeset).video_url
    end

    test "video_url is an valid url but not from youtube, so invalid" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: "http://pudim.com.br"})

      refute changeset.valid?
      assert "not an youtube valid URL" in errors_on(changeset).video_url
    end

    test "video_url must valid youtube url" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: "https://www.youtube.com/watch?v=YGMQU1L9LKg"})

      assert changeset.valid?

      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: "http://www.youtube.com/watch?v=YGMQU1L9LKg"})

      assert changeset.valid?

      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: "http://youtu.be/YGMQU1L9LKg"})

      assert changeset.valid?

      changeset =
        meeting_factory()
        |> Meeting.changeset(%{video_url: "https://youtu.be/YGMQU1L9LKg"})

      assert changeset.valid?
    end
  end

  test "video_id/0 must returns the video_id from video_url" do
    {:ok, meeting} =
      meeting_factory()
      |> Meeting.changeset(%{video_url: "https://www.youtube.com/watch?v=YGMQU1L9LKg"})
      |> Repo.insert()

    assert Meeting.video_id(meeting) == "YGMQU1L9LKg"
  end

  test "slugify name" do
    changeset =
      meeting_factory()
      |> Meeting.changeset(%{name: "my name"})

    assert Ecto.Changeset.get_field(changeset, :slug) == "my-name"

    changeset =
      meeting_factory()
      |> Meeting.changeset(%{name: "my name    otherNAME"})

    assert Ecto.Changeset.get_field(changeset, :slug) == "my-name-othername"

    changeset =
      meeting_factory()
      |> Meeting.changeset(%{name: "1-my xpa c"})

    assert Ecto.Changeset.get_field(changeset, :slug) == "1-my-xpa-c"
  end

  test "name slug must be unique" do
    params = %{
      name: "My name",
      description: "description",
      video_url: "https://www.youtube.com/watch?v=2d_6EQx3Z84"
    }

    {:ok, _schema} =
      %Meeting{}
      |> Meeting.changeset(params)
      |> Repo.insert()

    {:error, changeset} =
      %Meeting{}
      |> Meeting.changeset(params)
      |> Repo.insert()

    assert "has already been taken" in errors_on(changeset).slug

    {:ok, _schema} =
      meeting_factory(%{name: "test name"})
      |> Meeting.changeset(%{})
      |> Repo.insert()
  end
end
