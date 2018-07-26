defmodule Email.Protocol.Pop3Test do
  use ExUnit.Case
  doctest Agala.Provider.Email.Protocol.Pop3
  alias Agala.Provider.Email.Protocol.Pop3

  test "parse_headers returns map of headers" do
    exp_result = %{
      "To" => "<receiver@example.com>",
      "From" => "Sender <sender@example.com>",
      "Subject" =>
       "=?UTF-8?B?0LLQvtC/0YDQvtGBINC/0L4g0LrRgNC10LTQuNGC0YM=?=",
      "Message-ID" => "<7145c09c-ce5a-0b39-139d-40aeb323e668@cti.ru>",
      "Date" => "Tue, 30 Jan 2018 16:22:53 +0300",
      "User-Agent" =>
       "Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Thunderbird/52.5.2",
      "MIME-Version" => "1.0",
      "Content-Type" => "text/plain; charset=\"utf-8\"; format=flowed",
      "Content-Transfer-Encoding" => "8bit",
      "Content-Language" => "en-US"
    }
    assert {:message, ^exp_result, _} = Pop3.parse_headers({:message, mock_headers(), mock_content()})
  end

  test "parse_content returns list of parts" do
    exp_result = [
      %Pop3mail.Part{
        boundary: "",
        charset: "utf-8",
        content: "пожалуйста не присылайте коллекторов\r\n\r\n",
        content_id: "",
        content_location: "",
        filename: "",
        filename_charset: "us-ascii",
        index: 1,
        inline: nil,
        media_type: "text/plain",
        path: ""
      }
    ]
    assert {:message, _, ^exp_result} = Pop3.parse_content({:message, mock_headers(), mock_content()})
  end

  defp mock_headers() do
    [
      {:header, "To", "<receiver@example.com>"},
      {:header, "From", "Sender <sender@example.com>"},
      {:header, "Subject",
       "=?UTF-8?B?0LLQvtC/0YDQvtGBINC/0L4g0LrRgNC10LTQuNGC0YM=?="},
      {:header, "Message-ID", "<7145c09c-ce5a-0b39-139d-40aeb323e668@cti.ru>"},
      {:header, "Date", "Tue, 30 Jan 2018 16:22:53 +0300"},
      {:header, "User-Agent",
       "Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Thunderbird/52.5.2"},
      {:header, "MIME-Version", "1.0"},
      {:header, "Content-Type", "text/plain; charset=\"utf-8\"; format=flowed"},
      {:header, "Content-Transfer-Encoding", "8bit"},
      {:header, "Content-Language", "en-US"}
    ]
  end

  defp mock_content() do
    "пожалуйста не присылайте коллекторов\r\n\r\n"
  end
end
