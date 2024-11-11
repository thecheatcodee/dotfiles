local utils = {};

--- Clamps a value between a range
---@param val number
---@param min number
---@param max number
---@return number
utils.clamp = function (val, min, max)
	return math.min(math.max(val, min), max);
end

--- Linear interpolation between 2 values
---@param x number
---@param y number
---@param t number
---@return number
utils.lerp = function (x, y, t)
	return x + ((y - x) * t);
end

--- Checks if a highlight group exists or not
---@param hl string
---@return boolean
utils.hl_exists = function (hl)
	if not vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = hl })) then
		return true;
	elseif not vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "Markview" .. hl })) then
		return true;
	end

	return false;
end

--- Gets attached windows from a buffer ID
---@param buf integer
---@return integer[]
utils.find_attached_wins = function (buf)
	local attached_wins = {};

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			table.insert(attached_wins, win);
		end
	end

	return attached_wins;
end

--- Gets the start & stop line for a range from the cursor
---@param buffer integer
---@param window integer
---@return integer
---@return integer
utils.get_cursor_range = function (buffer, window)
	local cursor = vim.api.nvim_win_get_cursor(window or 0);
	local lines = vim.api.nvim_buf_line_count(buffer);

	return math.max(0, cursor[1] - 1), math.min(lines, cursor[1]);
end




--- Highlight group related helpers
local highlights = {};

local exists = utils.hl_exists;
local lerp = utils.lerp;
local clamp = utils.clamp;

--- Returns RGB value from the provided input
---@param input string | number[]
---@return number[]?
highlights.rgb = function (input)
	local lookup = {
		---+ ${class, Color name lookup table}
		["red"] = "#FF0000",        ["lightred"] = "#FFBBBB",      ["darkred"] = "#8B0000",
		["green"] = "#00FF00",      ["lightgreen"] = "#90EE90",    ["darkgreen"] = "#006400",    ["seagreen"] = "#2E8B57",
		["blue"] = "#0000FF",       ["lightblue"] = "#ADD8E6",     ["darkblue"] = "#00008B",     ["slateblue"] = "#6A5ACD",
		["cyan"] = "#00FFFF",       ["lightcyan"] = "#E0FFFF",     ["darkcyan"] = "#008B8B",
		["magenta"] = "#FF00FF",    ["lightmagenta"] = "#FFBBFF",  ["darkmagenta"] = "#8B008B",
		["yellow"] = "#FFFF00",     ["lightyellow"] = "#FFFFE0",   ["darkyellow"] = "#BBBB00",   ["brown"] = "#A52A2A",
		["grey"] = "#808080",       ["lightgrey"] = "#D3D3D3",     ["darkgrey"] = "#A9A9A9",
		["gray"] = "#808080",       ["lightgray"] = "#D3D3D3",     ["darkgray"] = "#A9A9A9",
		["black"] = "#000000",      ["white"] = "#FFFFFF",
		["orange"] = "#FFA500",     ["purple"] = "#800080",        ["violet"] = "#EE82EE"
		---_
	};

	local lookup_nvim = {
		---+ ${class, Neovim's color lookup table}
		["nvimdarkblue"] = "#004C73",    ["nvimlightblue"] = "#A6DBFF",
		["nvimdarkcyan"] = "#007373",    ["nvimlightcyan"] = "#8CF8F7",
		["nvimdarkgray1"] = "#07080D",   ["nvimlightgray1"] = "#EEF1F8",
		["nvimdarkgray2"] = "#14161B",   ["nvimlightgray2"] = "#E0E2EA",
		["nvimdarkgray3"] = "#2C2E33",   ["nvimlightgray3"] = "#C4C6CD",
		["nvimdarkgray4"] = "#4F5258",   ["nvimlightgray4"] = "#9B9EA4",
		["nvimdarkgrey1"] = "#07080D",   ["nvimlightgrey1"] = "#EEF1F8",
		["nvimdarkgrey2"] = "#14161B",   ["nvimlightgrey2"] = "#E0E2EA",
		["nvimdarkgrey3"] = "#2C2E33",   ["nvimlightgrey3"] = "#C4C6CD",
		["nvimdarkgrey4"] = "#4F5258",   ["nvimlightgrey4"] = "#9B9EA4",
		["nvimdarkgreen"] = "#005523",   ["nvimlightgreen"] = "#B3F6C0",
		["nvimdarkmagenta"] = "#470045", ["nvimlightmagenta"] = "#FFCAFF",
		["nvimdarkred"] = "#590008",     ["nvimlightred"] = "#FFC0B9",
		["nvimdarkyellow"] = "#6B5300",  ["nvimlightyellow"] = "#FCE094",
		---_
	};

	if type(input) == "string" then
		if input:match("%x%x%x%x%x%x$") then
			local r, g, b = input:match("(%x%x)(%x%x)(%x%x)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		elseif lookup[input] then
			local r, g, b = lookup[input]:match("(%x%x)(%x%x)(%x%x)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		elseif lookup_nvim[input] then
			local r, g, b = lookup_nvim[input]:match("(%x%x)(%x%x)(%x%x)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		end
	elseif type(input) == "number" then
		local r, g, b = string.format("%06x", input):match("(%x%x)(%x%x)(%x%x)$");

		return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
	elseif vim.islist(input) then
		local hue2rgb = function (p, q, t)
			if t < 0 then t = t + 1; end
			if t > 1 then t = t - 1; end

			if t < (1 / 6) then return p + (q - p) * 6 * t; end
			if t < (1 / 2) then return q; end
			if t < (2 / 3) then return p + (q - p) * 6 * (2 / 3 - t); end

			return p;
		end

		local r, g, b = input[3], input[3], input[3];

		if input[2] ~= 0 then
			local q = input[3] < 0.5 and input[3] * (1 + input[2]) or input[2] + input[3] - (input[2] * input[3]);
			local p = 2 * input[3] - q;

			r = hue2rgb(p, q, input[1] + (1 / 3));
			g = hue2rgb(p, q, input[1]);
			b = hue2rgb(p, q, input[1] - (1 / 3));
		end

		return { math.floor(r * 255), math.floor(g * 255), math.floor(b * 255) };
	end
end

--- Gets a value from a list of highlight groups
---@param value string
---@param array table
---@return any?
highlights.get = function (value, array)
	for _, item in ipairs(array) do
		if vim.fn.hlexists(item) and vim.api.nvim_get_hl(0, { name = item, link = false })[value] then
			return vim.api.nvim_get_hl(0, { name = item, link = false })[value];
		end
	end
end

--- Mixes 2 colors RGB values
---@param c_1 number[]
---@param c_2 number[]
---@param per_1 number
---@param per_2 number
---@return number[]
highlights.mix = function (c_1, c_2, per_1, per_2)
	local _r = clamp((c_1[1] * per_1) + (c_2[1] * per_2), 0, 255);
	local _g = clamp((c_1[2] * per_1) + (c_2[2] * per_2), 0, 255);
	local _b = clamp((c_1[3] * per_1) + (c_2[3] * per_2), 0, 255);

	return { math.floor(_r), math.floor(_g), math.floor(_b) };
end

--- Turns an RGB value to its hexadecimal string
---@param color any
---@return string
highlights.hex = function (color)
	return string.format("#%02x%02x%02x", math.floor(color[1]), math.floor(color[2]), math.floor(color[3]))
end

--- RGB to HSL converter
---@param color number[]
---@return number[]
highlights.hsl = function (color)
	for c, val in ipairs(color) do
		if val > 1 then
			color[c] = val / 255;
		end
	end

	local min, max = math.min(color[1], color[2], color[3]), math.max(color[1], color[2], color[3]);
	local hue, sature, lumen = nil, nil, (min + max) / 2;
	local delta = max - min;

	if max == min then
		hue = 0;
		sature = 0;
	else
		sature = lumen > 0.5 and delta / (2 - max - min) or delta / (max + min);

		if max == color[1] then
			hue = (color[2] - color[3]) / delta + (color[2] < color[3] and 6 or 0);
		elseif max == color[2] then
			hue = (color[3] - color[1]) / delta + 2;
		elseif max == color[3] then
			hue = (color[1] - color[2]) / delta + 4;
		end

		hue = hue / 6;
	end

	return { hue, sature, lumen };
end

--- Gets the luminosity of a RGB value
---@param color number[]
---@return number
highlights.lumen = function (color)
	for c, val in ipairs(color) do
		if val > 1 then
			color[c] = val / 255;
		end
	end

	local min, max = math.min(color[1], color[2], color[3]), math.max(color[1], color[2], color[3]);
	return (min + max) / 2;
end

--- Mixes 2 colors to fake opacity
---@param fg number[]
---@param bg number[]
---@param alpha number
---@return number[]
highlights.opacify = function (fg, bg, alpha)
	return {
		math.floor((fg[1] * alpha) + (bg[1] * (1 - alpha))),
		math.floor((fg[2] * alpha) + (bg[2] * (1 - alpha))),
		math.floor((fg[3] * alpha) + (bg[3] * (1 - alpha))),
	}
end


---@type string[]
highlights.created = {};

--- Checks if the background is dark or not
---@param light any?
---@param dark any?
---@return boolean | any
local isDark = function (light, dark)
	if light and dark then
		return vim.o.background == "dark" and dark or light;
	end

	return vim.o.background == "dark";
end

--- Creates highlight groups from an array of tables
---@param array markview.conf.hl[]
---@param list? "text" | "table"
highlights.create = function (array, list)
	local _c = {};

	if type(array) == "string" then
		if highlights[array] then
			array = highlights[array];
		else
			return;
		end
	end

	--- Create an array of usable tables
	for _, config in ipairs(array) do
		if type(config) ~= "table" then
			goto ignore;
		end

		if config.group_name and config.value then
			table.insert(_c, config);
		elseif config.output then
			local _o = config.output(highlights);

			if vim.islist(_o) then
				_c = vim.list_extend(_o, _c);
			elseif type(_o) == "table" and _o.group_name and _o.value then
				table.insert(_c, _o);
			end
		end

		::ignore::
	end

	local log_file;

	if list then
		log_file = io.open("mkvhl.txt", "w");

		if log_file and list == "table" then
			log_file:write("{", "\n");
		end
	end

	-- Apply the new highlight groups
	for _, color in ipairs(_c) do
		if type(color.group_name) == "string" and type(color.value) == "table" then
			-- Add the prefix
			if not color.group_name:match("^Markview") then
				color.group_name = "Markview" .. color.group_name;
			end

			vim.api.nvim_set_hl(0, color.group_name, color.value);
			table.insert(highlights.created, color.group_name)

			if log_file and list == "text" then
				log_file:write(color.group_name, "\n");
			elseif log_file and list == "table" then
				log_file:write("	{\n");
				log_file:write("		group_name = ", '"', color.group_name, '",', "\n");
				log_file:write("		value = {", "\n");

				for opt, value in pairs(color.value) do
					if type(value) == "string" then
						log_file:write("			", opt, " = ", '"', value, '"', ",", "\n");
					else
						log_file:write("			", opt, " = ", tostring(value), ",", "\n");
					end
				end

				log_file:write("		}", "\n");
				log_file:write("	},", "\n");
			end
		end
	end

	if log_file then
		if log_file and list == "table" then
			log_file:write("}");
		end

		log_file:close();
	end
end

--- Removes highlight groups
highlights.remove = function ()
	for index, item in ipairs(highlights.created) do
		vim.api.nvim_set_hl(0, item, {});
		table.remove(highlights.created, index);
	end
end

highlights.color = function (property, list, light, dark)
	return highlights.rgb(highlights.get(property, list) or isDark(light, dark));
end

local headingGenerator = function (checks, light, dark, group_name, suffix)
	local fg = highlights.color("fg", checks, light, dark);
	local l = highlights.lumen(highlights.color("fg", { "Normal" }, "#FFFFFF", "#000000"));

	local nr = highlights.rgb(highlights.get("bg", { "LineNr" }));
	local bg;

	if l < 0.5 then
		bg = highlights.opacify(fg, highlights.rgb("#FFFFFF") --[=[@as number[]]=], 0.25)
	else
		bg = highlights.opacify(fg, highlights.rgb("#1e1e2e") --[=[@as number[]]=], 0.25)

	end

	return {
		{
			group_name = group_name,
			value = {
				default = true,
				fg = highlights.hex(fg),
				bg = highlights.hex(bg)
			}
		},
		{
			group_name = group_name .. suffix,
			value = {
				default = true,
				fg = highlights.hex(fg),
				bg = nr and highlights.hex(nr) or nil
			}
		}
	};
end

-- 生成高亮组
local hlGenerator = function (checks, light, dark, group_name)
	local fg = highlights.color("fg", checks, light, dark);

	return {
		{
			group_name = group_name,
			value = {
				default = true,
				fg = highlights.hex(fg),
			}
		}
	};
end

---@type markview.conf.hl[]
highlights.dynamic = {
	---+ ${hl, Block quotes}
	{
		output = function ()
			return hlGenerator({ "Comment" }, "#9ca0b0", "#6c7086", "BlockQuoteDefault");
		end
	},
	{
		output = function ()
			return hlGenerator({ "DiagnosticError" }, "#D20F39", "#F38BA8", "BlockQuoteError");
		end
	},
	{
		output = function ()
			local fg = highlights.color("bg", { "@comment.note" }, nil, nil) or highlights.color("fg", { "@comment.note" }, "#1e66f5", "#89b4fa");

			return {
				{
					group_name = "BlockQuoteNote",
					value = {
						default = true,
						fg = highlights.hex(fg),
					}
				}
			};
		end
	},
	{
		output = function ()
			return hlGenerator({ "DiagnosticOk" }, "#40a02b", "#a6e3a1", "BlockQuoteOk");
		end
	},
	{
		output = function ()
			return hlGenerator({ "Conditional", "Keyword" }, "#8839ef", "#cba6f7", "BlockQuoteSpecial");
		end
	},
	{
		output = function ()
			return hlGenerator({ "DiagnosticWarn" }, "#DF8E1D", "#F9E3AF", "BlockQuoteWarn");
		end
	},
	---_

	---+ ${hl, Checkbox}
	{
		output = function ()
			return hlGenerator({ "Comment" }, "#9ca0b0", "#6c7086", "CheckboxCancelled");
		end
	},
	{
		output = function ()
			return hlGenerator({ "DiagnosticOk" }, "#40a02b", "#a6e3a1", "CheckboxChecked");
		end
	},
	{
		output = function ()
			return hlGenerator({ "DiagnosticWarn" }, "#DF8E1D", "#F9E3AF", "CheckboxPending");
		end
	},
	{
		output = function ()
			return hlGenerator({ "Conditional", "Keyword" }, "#8839ef", "#cba6f7", "CheckboxProgress");
		end
	},
	{
		output = function ()
			return hlGenerator({ "DiagnosticError" }, "#D20F39", "#F38BA8", "CheckboxUnchecked");
		end
	},
	{
		output = function (util)
			local fg = util.color("fg", { "Comment" }, "#9ca0b0", "#6c7086");

			return {
				group_name = "CheckboxStriked",
				value = {
					fg = util.hex(fg),
					strikethrough = true
				}
			};
		end
	},
	---_

	---+ ${hl, Code blocks}
	{
		output = function (util)
			local bg = util.hsl(util.color("bg", { "Normal" }, "#CDD6F4", "#1E1E2E"));
			local fg = util.color("fg", { "Comment" }, "#9ca0b0", "#6c7086");

			local nr = util.get("bg", { "LineNr" });
			local inl = vim.deepcopy(bg);

			local c1 = highlights.color("fg", {
				"markdownH1", "@markup.heading.1.markdown", "@markup.heading"
			}, "#F38BA8", "#D20F39")
			local c2 = highlights.color("fg", {
				"markdownH2", "@markup.heading.2.markdown", "@markup.heading"
			}, "#FAB387", "#FE640B")
			local c3 = highlights.color("fg", {
				"markdownH3", "@markup.heading.3.markdown", "@markup.heading"
			}, "#F9E2AF", "#DF8E1D")
			local c4 = highlights.color("fg", {
				"markdownH4", "@markup.heading.4.markdown", "@markup.heading"
			}, "#A6E3A1", "#40A02B")
			local c5 = highlights.color("fg", {
				"markdownH5", "@markup.heading.5.markdown", "@markup.heading"
			}, "#74C7EC", "#209FB5")
			local c6 = highlights.color("fg", {
				"markdownH6", "@markup.heading.6.markdown", "@markup.heading"
			}, "#B4BEFE", "#7287FD")

			if bg[3] > 0.5 then
				bg[3] = clamp(bg[3] - 0.05, 0.1, 0.9);
				inl[3] = clamp(inl[3] - 0.10, 0.1, 0.9);
			else
				bg[3] = clamp(bg[3] + 0.05, 0.1, 0.9);
				inl[3] = clamp(inl[3] + 0.10, 0.1, 0.9);
			end

			bg = util.hex(util.rgb(bg));

			return {
				{
					group_name = "Code",
					value = {
						default = true,
						bg = bg,
					}
				},
				{
					group_name = "CodeInfo",
					value = {
						default = true,
						bg = bg,
						fg = util.hex(fg),
					}
				},

				{
					group_name = "InlineCode",
					value = {
						default = true,
						bg = util.hex(util.rgb(inl)),
					}
				},

				{
					group_name = "Icon1",
					value = { default = true, bg = bg, fg = util.hex(c1) }
				},
				{
					group_name = "Icon1Sign",
					value = { default = true, bg = nr, fg = util.hex(c1) }
				},
				{
					group_name = "Icon1Fg",
					value = { default = true, fg = util.hex(c1) }
				},
				{ group_name = "Icon2", value = { default = true, bg = bg, fg = util.hex(c2) } },
				{ group_name = "Icon2Sign", value = { default = true, bg = nr, fg = util.hex(c2) } },
				{ group_name = "Icon2Fg", value = { default = true, fg = util.hex(c2) } },
				{ group_name = "Icon3", value = { default = true, bg = bg, fg = util.hex(c3) } },
				{ group_name = "Icon3Sign", value = { default = true, bg = nr, fg = util.hex(c3) } },
				{ group_name = "Icon3Fg", value = { default = true, fg = util.hex(c3) } },
				{ group_name = "Icon4", value = { default = true, bg = bg, fg = util.hex(c4) } },
				{ group_name = "Icon4Sign", value = { default = true, bg = nr, fg = util.hex(c4) } },
				{ group_name = "Icon4Fg", value = { default = true, fg = util.hex(c4) } },
				{ group_name = "Icon5", value = { default = true, bg = bg, fg = util.hex(c5) } },
				{ group_name = "Icon5Sign", value = { default = true, bg = nr, fg = util.hex(c5) } },
				{ group_name = "Icon5Fg", value = { default = true, fg = util.hex(c5) } },
				{ group_name = "Icon6", value = { default = true, bg = bg, fg = util.hex(c6) } },
				{ group_name = "Icon6Sign", value = { default = true, bg = nr, fg = util.hex(c6) } },
				{ group_name = "Icon6Fg", value = { default = true, fg = util.hex(c6) } },
			}
		end
	},
	---_

	---+ ${hl, Heading 1}
	{
		output = function ()
			return headingGenerator(
				{
					"markdownH1", "@markup.heading.1.markdown", "@markup.heading"
				},
				"#F38BA8",
				"#D20F39",

				"Heading1",
				"Sign"
			);
		end
	},
	---_
	---+ ${hl, Heading 2}
	{
		output = function ()
			return headingGenerator(
				{
					"markdownH2", "@markup.heading.2.markdown", "@markup.heading"
				},
				"#FAB387",
				"#FE640B",

				"Heading2",
				"Sign"
			);
		end
	},
	---_
	---+ ${hl, Heading 3}
	{
		output = function ()
			return headingGenerator(
				{
					"markdownH3", "@markup.heading.3.markdown", "@markup.heading"
				},
				"#F9E2AF",
				"#DF8E1D",

				"Heading3",
				"Sign"
			);
		end
	},
	---_
	---+ ${hl, Heading 4}
	{
		output = function ()
			return headingGenerator(
				{
					"markdownH4", "@markup.heading.4.markdown", "@markup.heading"
				},
				"#A6E3A1",
				"#40A02B",

				"Heading4",
				"Sign"
			);
		end
	},
	---_
	---+ ${hl, Heading 5}
	{
		output = function ()
			return headingGenerator(
				{
					"markdownH5", "@markup.heading.5.markdown", "@markup.heading"
				},
				"#74C7EC",
				"#209FB5",

				"Heading5",
				"Sign"
			);
		end
	},
	---_
	---+ ${hl, Heading 6}
	{
		output = function ()
			return headingGenerator(
				{
					"markdownH6", "@markup.heading.6.markdown", "@markup.heading"
				},
				"#B4BEFE",
				"#7287FD",

				"Heading6",
				"Sign"
			);
		end
	},
	---_

	---+ ${hl, Horizontal rule}
	{
		output = function (util)
			local from = util.color("bg", { "Normal" }, "#1E1E2E", "#CDD6F4");
			local to   = util.color("fg", { "Title" }, "#1e66f5", "#89b4fa");

			local _o = {};

			for l = 0, 9 do
				local _r = lerp(from[1], to[1], l / 9);
				local _g = lerp(from[2], to[2], l / 9);
				local _b = lerp(from[3], to[3], l / 9);

				table.insert(_o, {
					group_name = "Gradient" .. (l + 1),
					value = {
						default = true,
						fg = util.hex({ _r, _g, _b })
					}
				});
			end

			return _o;
		end
	},
	---_

	---+ ${hl, Links}
	{
		output = function (util)
			return {
				group_name = "Hyperlink",
				value = {
					default = true,
					link = "@markup.link.label.markdown_inline"
				}
			}
		end
	},
	{
		output = function (util)
			return {
				group_name = "ImageLink",
				value = {
					default = true,
					link = "@markup.link.label.markdown_inline"
				}
			}
		end
	},
	{
		output = function (util)
			return {
				group_name = "Email",
				value = {
					default = true,
					link = "@markup.link.url.markdown_inline"
				}
			}
		end
	},
	---_

	---+ ${hl, Latex}
	{
		output = function (util)
			local sub = util.color("bg", { "DiagnosticWarn" }, "#DF8E1D", "#F9E3AF");
			local sup = util.color("bg", { "DiagnosticOk" }, "#40a02b", "#a6e3a1");

			local bg = util.color("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");

			return {
				{
					group_name = "LatexSubscript",
					value = {
						default = true,
						fg = util.hex(util.opacify(sub, bg, 0.6)),
						italic = true
					}
				},
				{
					group_name = "LatexSuperscript",
					value = {
						default = true,
						fg = util.hex(util.opacify(sup, bg, 0.6)),
						italic = true
					}
				}
			}
		end
	},
	---_

	---+ ${hl, List items}
	{
		output = function ()
			return hlGenerator({ "DiagnosticWarn" }, "#DF8E1D", "#F9E3AF", "ListItemMinus");
		end
	},
	{
		output = function ()
			return hlGenerator({ "DiagnosticOk" }, "#40a02b", "#a6e3a1", "ListItemPlus");
		end
	},
	{
		output = function ()
			local fg = highlights.color("bg", { "@comment.note" }, nil, nil) or highlights.color("fg", { "@comment.note" }, "#1e66f5", "#89b4fa");

			return {
				{
					group_name = "MarkviewListItemStar",
					value = {
						default = true,
						fg = highlights.hex(fg),
					}
				}
			};
		end
	},
	---_

	---+ ${hl, Tables}
	{
		output = function ()
			local fg = highlights.color("bg", { "@comment.note" }, nil, nil) or highlights.color("fg", { "@comment.note" }, "#1e66f5", "#89b4fa");
			local headerFg = highlights.color("fg", { "DiagnosticInfo" }, nil, nil) or highlights.color("fg", { "@comment.note" }, "#179299",  "#94e2d5");

			return {
				{
					group_name = "TableHeader",
					value = {
						default = true,
						fg = highlights.hex(headerFg),
					}
				},
				{
					group_name = "TableBorder",
					value = {
						default = true,
						fg = highlights.hex(fg),
					}
				},
				{
					group_name = "TableAlignCenter",
					value = {
						default = true,
						fg = highlights.hex(headerFg),
					}
				},
				{
					group_name = "TableAlignLeft",
					value = {
						default = true,
						fg = highlights.hex(headerFg),
					}
				},
				{
					group_name = "TableAlignRight",
					value = {
						default = true,
						fg = highlights.hex(headerFg),
					}
				}
			};
		end
	},
	---_
};

--- 静态暗色高亮组
---@type markview.conf.hl[]
highlights.dark = {
	---+ ${hl, Dark static highlight group}
	{
		group_name = "MarkviewTableHeader",
		value = {
			default = true,
			fg = "#89dceb",
		}
	},
	{
		group_name = "MarkviewTableBorder",
		value = {
			default = true,
			fg = "#89b4fa",
		}
	},
	{
		group_name = "MarkviewTableAlignCenter",
		value = {
			default = true,
			fg = "#89dceb",
		}
	},
	{
		group_name = "MarkviewTableAlignLeft",
		value = {
			default = true,
			fg = "#89dceb",
		}
	},
	{
		group_name = "MarkviewTableAlignRight",
		value = {
			default = true,
			fg = "#89dceb",
		}
	},
	{
		group_name = "MarkviewListItemStar",
		value = {
			default = true,
			fg = "#89b4fa",
		}
	},
	{
		group_name = "MarkviewListItemPlus",
		value = {
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewListItemMinus",
		value = {
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewLatexSubscript",
		value = {
			fg = "#a1947b",
			default = true,
			italic = true,
		}
	},
	{
		group_name = "MarkviewLatexSuperscript",
		value = {
			fg = "#6f9473",
			default = true,
			italic = true,
		}
	},
	{
		group_name = "MarkviewGradient1",
		value = {
			default = true,
			fg = "#1e1e2e",
		}
	},
	{
		group_name = "MarkviewGradient2",
		value = {
			default = true,
			fg = "#292e44",
		}
	},
	{
		group_name = "MarkviewGradient3",
		value = {
			default = true,
			fg = "#353f5b",
		}
	},
	{
		group_name = "MarkviewGradient4",
		value = {
			default = true,
			fg = "#415072",
		}
	},
	{
		group_name = "MarkviewGradient5",
		value = {
			default = true,
			fg = "#4d6088",
		}
	},
	{
		group_name = "MarkviewGradient6",
		value = {
			default = true,
			fg = "#59719f",
		}
	},
	{
		group_name = "MarkviewGradient7",
		value = {
			default = true,
			fg = "#6582b6",
		}
	},
	{
		group_name = "MarkviewGradient8",
		value = {
			default = true,
			fg = "#7192cc",
		}
	},
	{
		group_name = "MarkviewGradient9",
		value = {
			default = true,
			fg = "#7da3e3",
		}
	},
	{
		group_name = "MarkviewGradient10",
		value = {
			default = true,
			fg = "#89b4fa",
		}
	},
	{
		group_name = "MarkviewHeading6",
		value = {
			bg = "#434662",
			default = true,
			fg = "#b4befe",
		}
	},
	{
		group_name = "MarkviewHeading6Sign",
		value = {
			default = true,
			fg = "#b4befe",
		}
	},
	{
		group_name = "MarkviewHeading5",
		value = {
			bg = "#33485d",
			default = true,
			fg = "#74c7ec",
		}
	},
	{
		group_name = "MarkviewHeading5Sign",
		value = {
			default = true,
			fg = "#74c7ec",
		}
	},
	{
		group_name = "MarkviewHeading4",
		value = {
			bg = "#404f4a",
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewHeading4Sign",
		value = {
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewHeading3",
		value = {
			bg = "#544f4e",
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewHeading3Sign",
		value = {
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewHeading2",
		value = {
			bg = "#554344",
			default = true,
			fg = "#fab387",
		}
	},
	{
		group_name = "MarkviewHeading2Sign",
		value = {
			default = true,
			fg = "#fab387",
		}
	},
	{
		group_name = "MarkviewHeading1",
		value = {
			bg = "#53394c",
			default = true,
			fg = "#f38ba8",
		}
	},
	{
		group_name = "MarkviewHeading1Sign",
		value = {
			default = true,
			fg = "#f38ba8",
		}
	},
	{
		group_name = "MarkviewCode",
		value = {
			default = true,
			bg = "#28283d",
		}
	},
	{
		group_name = "MarkviewCodeInfo",
		value = {
			bg = "#28283d",
			default = true,
			fg = "#9399b2",
		}
	},
	{
		group_name = "MarkviewInlineCode",
		value = {
			default = true,
			bg = "#32324c",
		}
	},
	{
		group_name = "MarkviewIcon1",
		value = {
			bg = "#28283d",
			default = true,
			fg = "#f38ba8",
		}
	},
	{
		group_name = "MarkviewIcon1Sign",
		value = {
			default = true,
			fg = "#f38ba8",
		}
	},
	{
		group_name = "MarkviewIcon1Fg",
		value = {
			default = true,
			fg = "#f38ba8",
		}
	},
	{
		group_name = "MarkviewIcon2",
		value = {
			bg = "#28283d",
			default = true,
			fg = "#fab387",
		}
	},
	{
		group_name = "MarkviewIcon2Sign",
		value = {
			default = true,
			fg = "#fab387",
		}
	},
	{
		group_name = "MarkviewIcon2Fg",
		value = {
			default = true,
			fg = "#fab387",
		}
	},
	{
		group_name = "MarkviewIcon3",
		value = {
			bg = "#28283d",
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewIcon3Sign",
		value = {
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewIcon3Fg",
		value = {
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewIcon4",
		value = {
			bg = "#28283d",
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewIcon4Sign",
		value = {
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewIcon4Fg",
		value = {
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewIcon5",
		value = {
			bg = "#28283d",
			default = true,
			fg = "#74c7ec",
		}
	},
	{
		group_name = "MarkviewIcon5Sign",
		value = {
			default = true,
			fg = "#74c7ec",
		}
	},
	{
		group_name = "MarkviewIcon5Fg",
		value = {
			default = true,
			fg = "#74c7ec",
		}
	},
	{
		group_name = "MarkviewIcon6",
		value = {
			bg = "#28283d",
			default = true,
			fg = "#b4befe",
		}
	},
	{
		group_name = "MarkviewIcon6Sign",
		value = {
			default = true,
			fg = "#b4befe",
		}
	},
	{
		group_name = "MarkviewIcon6Fg",
		value = {
			default = true,
			fg = "#b4befe",
		}
	},
	{
		group_name = "MarkviewCheckboxUnchecked",
		value = {
			default = true,
			fg = "#f38ba8",
		}
	},
	{
		group_name = "MarkviewCheckboxProgress",
		value = {
			default = true,
			fg = "#cba6f7",
		}
	},
	{
		group_name = "MarkviewCheckboxPending",
		value = {
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewCheckboxChecked",
		value = {
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewCheckboxCancelled",
		value = {
			default = true,
			fg = "#9399b2",
		}
	},
	{
		group_name = "MarkviewCheckboxStriked",
		value = {
			default = true,
			strikethrough = true,
			bg = "#28283d",
		}
	},
	{
		group_name = "MarkviewBlockQuoteWarn",
		value = {
			default = true,
			fg = "#f9e2af",
		}
	},
	{
		group_name = "MarkviewBlockQuoteSpecial",
		value = {
			default = true,
			fg = "#cba6f7",
		}
	},
	{
		group_name = "MarkviewBlockQuoteOk",
		value = {
			default = true,
			fg = "#a6e3a1",
		}
	},
	{
		group_name = "MarkviewBlockQuoteNote",
		value = {
			default = true,
			fg = "#89b4fa",
		}
	},
	{
		group_name = "MarkviewBlockQuoteError",
		value = {
			default = true,
			fg = "#f38ba8",
		}
	},
	{
		group_name = "MarkviewBlockQuoteDefault",
		value = {
			default = true,
			fg = "#9399b2",
		}
	},
	{
		group_name = "MarkviewHyperlink",
		value = {
			link = "@markup.link.label.markdown_inline",
			default = true,
		}
	},
	{
		group_name = "MarkviewImageLink",
		value = {
			link = "@markup.link.label.markdown_inline",
			default = true,
		}
	},
	{
		group_name = "MarkviewEmail",
		value = {
			link = "@markup.link.url.markdown_inline",
			default = true,
		}
	},
	---_
};

--- 静态亮色高亮组
---@type markview.conf.hl[]
highlights.light = {
	---+ ${hl, Light static highlight groups}
	{
		group_name = "MarkviewTableHeader",
		value = {
			fg = "#04a5e5",
			default = true,
		}
	},
	{
		group_name = "MarkviewTableBorder",
		value = {
			fg = "#1e66f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewTableAlignCenter",
		value = {
			fg = "#04a5e5",
			default = true,
		}
	},
	{
		group_name = "MarkviewTableAlignLeft",
		value = {
			fg = "#04a5e5",
			default = true,
		}
	},
	{
		group_name = "MarkviewTableAlignRight",
		value = {
			fg = "#04a5e5",
			default = true,
		}
	},
	{
		group_name = "MarkviewListItemStar",
		value = {
			fg = "#1e66f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewListItemPlus",
		value = {
			fg = "#40a02b",
			default = true,
		}
	},
	{
		group_name = "MarkviewListItemMinus",
		value = {
			fg = "#df8e1d",
			default = true,
		}
	},
	{
		group_name = "MarkviewLatexSubscript",
		value = {
			italic = true,
			fg = "#e5b573",
			default = true,
		}
	},
	{
		group_name = "MarkviewLatexSuperscript",
		value = {
			italic = true,
			fg = "#86c07b",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient1",
		value = {
			fg = "#eff1f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient2",
		value = {
			fg = "#d7e1f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient3",
		value = {
			fg = "#c0d2f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient4",
		value = {
			fg = "#a9c2f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient5",
		value = {
			fg = "#92b3f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient6",
		value = {
			fg = "#7aa3f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient7",
		value = {
			fg = "#6394f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient8",
		value = {
			fg = "#4c84f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient9",
		value = {
			fg = "#3575f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewGradient10",
		value = {
			fg = "#1e66f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading6",
		value = {
			bg = "#dbe1fe",
			fg = "#7287fd",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading6Sign",
		value = {
			fg = "#7287fd",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading5",
		value = {
			bg = "#c7e7ec",
			fg = "#209fb5",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading5Sign",
		value = {
			fg = "#209fb5",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading4",
		value = {
			bg = "#cfe7ca",
			fg = "#40a02b",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading4Sign",
		value = {
			fg = "#40a02b",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading3",
		value = {
			bg = "#f7e2c6",
			fg = "#df8e1d",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading3Sign",
		value = {
			fg = "#df8e1d",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading2",
		value = {
			bg = "#fed8c2",
			fg = "#fe640b",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading2Sign",
		value = {
			fg = "#fe640b",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading1",
		value = {
			bg = "#f3c3cd",
			fg = "#d20f39",
			default = true,
		}
	},
	{
		group_name = "MarkviewHeading1Sign",
		value = {
			fg = "#d20f39",
			default = true,
		}
	},
	{
		group_name = "MarkviewCode",
		value = {
			bg = "#dfe3eb",
			default = true,
		}
	},
	{
		group_name = "MarkviewCodeInfo",
		value = {
			default = true,
			fg = "#7c7f93",
			bg = "#dfe3eb",
		}
	},
	{
		group_name = "MarkviewInlineCode",
		value = {
			bg = "#cfd5e1",
			default = true,
		}
	},
	{
		group_name = "MarkviewIcon1",
		value = {
			default = true,
			fg = "#d20f39",
			bg = "#dfe3eb",
		}
	},
	{
		group_name = "MarkviewIcon1Sign",
		value = {
			default = true,
			fg = "#d20f39",
		}
	},
	{
		group_name = "MarkviewIcon1Fg",
		value = {
			fg = "#d20f39",
			default = true,
		}
	},
	{
		group_name = "MarkviewIcon2",
		value = {
			default = true,
			fg = "#fe640b",
			bg = "#dfe3eb",
		}
	},
	{
		group_name = "MarkviewIcon2Sign",
		value = {
			default = true,
			fg = "#fe640b",
		}
	},
	{
		group_name = "MarkviewIcon2Fg",
		value = {
			fg = "#fe640b",
			default = true,
		}
	},
	{
		group_name = "MarkviewIcon3",
		value = {
			default = true,
			fg = "#df8e1d",
			bg = "#dfe3eb",
		}
	},
	{
		group_name = "MarkviewIcon3Sign",
		value = {
			default = true,
			fg = "#df8e1d",
		}
	},
	{
		group_name = "MarkviewIcon3Fg",
		value = {
			fg = "#df8e1d",
			default = true,
		}
	},
	{
		group_name = "MarkviewIcon4",
		value = {
			default = true,
			fg = "#40a02b",
			bg = "#dfe3eb",
		}
	},
	{
		group_name = "MarkviewIcon4Sign",
		value = {
			default = true,
			fg = "#40a02b",
		}
	},
	{
		group_name = "MarkviewIcon4Fg",
		value = {
			fg = "#40a02b",
			default = true,
		}
	},
	{
		group_name = "MarkviewIcon5",
		value = {
			default = true,
			fg = "#209fb5",
			bg = "#dfe3eb",
		}
	},
	{
		group_name = "MarkviewIcon5Sign",
		value = {
			default = true,
			fg = "#209fb5",
		}
	},
	{
		group_name = "MarkviewIcon5Fg",
		value = {
			fg = "#209fb5",
			default = true,
		}
	},
	{
		group_name = "MarkviewIcon6",
		value = {
			default = true,
			fg = "#7287fd",
			bg = "#dfe3eb",
		}
	},
	{
		group_name = "MarkviewIcon6Sign",
		value = {
			default = true,
			fg = "#7287fd",
		}
	},
	{
		group_name = "MarkviewIcon6Fg",
		value = {
			fg = "#7287fd",
			default = true,
		}
	},
	{
		group_name = "MarkviewCheckboxUnchecked",
		value = {
			fg = "#d20f39",
			default = true,
		}
	},
	{
		group_name = "MarkviewCheckboxProgress",
		value = {
			fg = "#8839ef",
			default = true,
		}
	},
	{
		group_name = "MarkviewCheckboxPending",
		value = {
			fg = "#df8e1d",
			default = true,
		}
	},
	{
		group_name = "MarkviewCheckboxChecked",
		value = {
			fg = "#40a02b",
			default = true,
		}
	},
	{
		group_name = "MarkviewCheckboxCancelled",
		value = {
			fg = "#7c7f93",
			default = true,
		}
	},
	{
		group_name = "MarkviewCheckboxStriked",
		value = {
			bg = "#dfe3eb",
			strikethrough = true,
			default = true,
		}
	},
	{
		group_name = "MarkviewBlockQuoteWarn",
		value = {
			fg = "#df8e1d",
			default = true,
		}
	},
	{
		group_name = "MarkviewBlockQuoteSpecial",
		value = {
			fg = "#8839ef",
			default = true,
		}
	},
	{
		group_name = "MarkviewBlockQuoteOk",
		value = {
			fg = "#40a02b",
			default = true,
		}
	},
	{
		group_name = "MarkviewBlockQuoteNote",
		value = {
			fg = "#1e66f5",
			default = true,
		}
	},
	{
		group_name = "MarkviewBlockQuoteError",
		value = {
			fg = "#d20f39",
			default = true,
		}
	},
	{
		group_name = "MarkviewBlockQuoteDefault",
		value = {
			fg = "#7c7f93",
			default = true,
		}
	},
	{
		group_name = "MarkviewHyperlink",
		value = {
			link = "@markup.link.label.markdown_inline",
			default = true,
		}
	},
	{
		group_name = "MarkviewImageLink",
		value = {
			link = "@markup.link.label.markdown_inline",
			default = true,
		}
	},
	{
		group_name = "MarkviewEmail",
		value = {
			link = "@markup.link.url.markdown_inline",
			default = true,
		}
	},
	---_
}

return highlights;

-- highlights.create()

