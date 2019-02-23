
defmodule GithubOmgWeb.Paginator do

  @moduledoc """
  A module that implements functions for performing simple pagination functionality

  Invoke it using the module's `call` function that takes a struct as parameter.

  ## Struct key values

    - total: The total amount of records (mandatory)
    - page: The page currently on (default: 1)
    - per_page: The number of records per page (default: 10)
    - max_display: The number of pages displayed in the pagination menu (default: 10)
    - max_results: Optional argument that limits the total number of records it can paginate

  ## Examples

    iex> Paginator.call %Paginator(total: 1000)

    %Paginator.Output{
      first: nil,
      last: 100,
      next: 2,
      page: 1,
      pages: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      previous: nil
    }

  """

  # The struct with the pagination info that gets returned
  defmodule Output do
    defstruct [:page, :first, :last, :previous, :next, :pages]
  end

  @doc """
  # Struct that's passed to the module used to calculate the pagination data
  """
  @enforce_keys [:total]
  defstruct page: 1, per_page: 10, total: nil, max_display: 10, max_results: nil

  @doc """
  Invokes the module. Takes a struct with the input and returns a struct with the pagination data
  """
  def call(data) do

    data = data
      |> Map.put(:total_pages, total_pages(data))
      |> Map.put(:half, half(data))

    %Output{
      page: data.page,
      first: first(data),
      last: last(data),
      pages: pages(data),
      previous: previous(data),
      next: next(data)
    }
  end

  # Returns the total pagee.
  #0 if total less than per page. limits if max_results is specified and total is more than max_results
  defp total_pages(data) do
    cond do
      data.total <= data.per_page ->
        0
      data.max_results !== nil and data.max_results < data.total ->
        Kernel.trunc(data.max_results / data.per_page)
      true ->
        Kernel.trunc(data.total / data.per_page)
    end
  end

  # Returns the first page
  defp first(data) do
    if data.total >= data.per_page and data.page !== 1, do: 1, else: nil
  end

  # Returns the last page
  defp last(data) do
    if data.page < data.total_pages, do: data.total_pages, else: nil
  end

  # Returns the half value of `max_display` rounded down
  defp half(data) do
    Kernel.trunc(data.max_display / 2)
  end

  # Returns the `pages` list. The number of list items depends on the number specified in `max_display`
  defp pages(data) do
    if data.total_pages == 0, do: [], else: Enum.to_list begin_pages(data)..end_pages(data)
  end

  # Returns the page that the `pages` list starts on
  defp begin_pages(data) do
    cond do
      data.page + data.half >= data.total_pages ->
        # when reaching the end
        data.total_pages - (data.max_display - 1)
      data.page > data.half ->
        # odd vs even pages
        if rem(data.max_display, 2) === 0 do
          data.page - (data.half - 1)
        else
          data.page - data.half
        end
      true ->
        1
    end
  end

  # Returns the page that the `pages` list ends on
  defp end_pages(data) do
    end_page = data.page + data.half
    cond do
      end_page >= data.total_pages ->
        # when reaching the end
        data.total_pages
      data.page <= data.half ->
        data.max_display
      true ->
        end_page
    end
  end

  # Returns the page number that is prior than the current page.
  # If the current page is 1 it returns nil
  defp previous(data) do
    if data.page > 1, do: data.page - 1, else: nil
  end

  # Returns the page number that is latter than the current page.
  # If the current page is equal to the last it returns nil
  defp next(data) do
    if data.page < data.total_pages, do: data.page + 1, else: nil
  end
end
