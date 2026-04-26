# _unal_executor.jl
# Definicion de _unal_core_executor compatible con Julia 1.11.3.
# Adaptado del helper del profesor pero sin la rama is_plot ni el
# redirect_stdout(IOBuffer) que ya no funcionan en 1.11.

function _unal_core_executor(code, is_plot, filename, dpi, w, h, fontsize)
    # Construir prompt estilo REPL con el codigo
    lines = split(code, "\n")
    io_code = IOBuffer()
    first = true
    for ln in lines
        if isempty(strip(ln))
            continue
        end
        if first
            println(io_code, "julia> ", ln)
            first = false
        else
            println(io_code, "       ", ln)
        end
    end

    # Capturar stdout/stderr usando Pipe (Julia 1.11 ya no acepta IOBuffer)
    pipe_out = Pipe()
    pipe_err = Pipe()
    val = nothing

    redirect_stdio(stdout = pipe_out, stderr = pipe_err) do
        try
            val = include_string(Main, code)
        catch e
            showerror(stderr, e)
            println(stderr)
        end
    end

    close(pipe_out.in)
    close(pipe_err.in)

    out_str = read(pipe_out, String)
    err_str = read(pipe_err, String)

    if !is_plot && !(val === nothing) && isempty(strip(out_str))
        out_str = string(val) * "\n"
    end

    return String(take!(io_code)) * out_str * err_str
end
