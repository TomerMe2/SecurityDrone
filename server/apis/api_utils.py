from flask import Response


def do_and_return_response(function_to_do):
    """
    :param function_to_do: function () => bool
    :return: response correspond with the function results
    """

    try:
        has_succeeded = function_to_do()
    except Exception as e:
        return Response(status=400)

    if has_succeeded:
        return Response(status=200)
    else:
        return Response(status=400)
