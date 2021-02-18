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

    test "description must not be blank" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{description: ""})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).description
    end

    test "description must not be nil" do
      changeset =
        meeting_factory()
        |> Meeting.changeset(%{description: nil})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).description
    end

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
  end
end
