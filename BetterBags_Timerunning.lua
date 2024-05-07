---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon("BetterBags")

---@class Categories: AceModule
local categories = addon:GetModule('Categories')

---@class Localization: AceModule
local L = addon:GetModule('Localization')

local config = addon:GetModule('Config')

local metaCategoryName = "Gem - Head"
local prismaticCategoryName = "Gem - Chest, Pants"
local tinkerCategoryName = "Gem - Shoulder, Wrist, Hand, Belt"
local cogwheelCategoryName = "Gem - Feet"
local buffScrollsCategoryName = "Class Buffs"
local utilityCategoryName = "Timerunning Class Utilities"
local flasksCategoryName = "Timerunning Flasks"

local metaCategoryEnabled = true
local prismaticCategoryEnabled = true
local tinkerCategoryEnabled = true
local cogwheelCategoryEnabled = true
local buffScrollsCategoryEnabled = true
local utilityCategoryEnabled = true
local flasksCategoryEnabled = true

local pendingChanges = false

local MetaGems = {
  220211, -- Precipice of Madness
  216695, -- Lifestorm
  216671, -- Thundering Orb
  216711, -- Chi-ji, the Red Crane
  216663, -- Oblivion Sphere
  220117, -- Ward of Salvation
  220120, -- Soul Tether
  221982, -- Bulwark of the Black Ox
  219386, -- Locus of Power
  221977, -- Funeral Pyre
--  216974, -- Morphing Elements  -- not implemented on ptr
  219878, -- Tireless Spirit
}

local Tinkers = {
  217907, -- Warmth
  219817, -- Freedom
  212361, -- Opportunist
  219452, -- Static Charge
  212916, -- Frost Armor
  216628, -- Victory Fire
  216647, -- Hailstorm
  217927, -- Savior
  212758, -- Incendiary Terror
  216650, -- Memory of Vengeance
  217964, -- Holy Martyr
  219389, -- Lightning Rod
  219516, -- Windweaver
  219818, -- Brilliance
  216625, -- Quick Strike
  216651, -- Searing Light
  217903, -- Vindication
  217961, -- Righteous Frenzy
  212365, -- Fervor
  217957, -- Deliverance
  212749, -- Explosive Barrage
  219527, -- Vampiric Aura
  212366, -- Arcanist's Edge
  212759, -- Meteor Storm
  219523, -- Storm Overload
  219801, -- Ankh of Reincarnation
  219944, -- Bloodthirsty Coral
  212694, -- Enkindle
  216648, -- Cold Front
  216649, -- Brittle
  219777, -- Grounding
  212362, -- Sunstrider's Flourish
  216626, -- Slay
  216627, -- Tinkmaster's Shield
  212760, -- Wildfire
  216624, -- Mark of Arrogance
}

local Prismatic = {
  210714, -- Chipped Deadly Sapphire
  210717, -- Chipped Hungering Ruby
  210715, -- Chipped Masterful Amethyst
  210681, -- Chipped Quick Topaz
  220367, -- Chipped Stalwart Pearl
  211109, -- Chipped Sustaining Emerald
  210716, -- Chipped Swift Opal
  220371, -- Chipped Versatile Diamond
  211123, -- Deadly Sapphire
  216644, -- Flawed Deadly Sapphire
  216641, -- Flawed Hungering Ruby
  216640, -- Flawed Masterful Amethyst
  216643, -- Flawed Quick Topaz
  220368, -- Flawed Stalwart Pearl
  216642, -- Flawed Sustaining Emerald
  216639, -- Flawed Swift Opal
  220372, -- Flawed Versatile Diamond
  210718, -- Hungering Ruby
  211106, -- Masterful Amethyst
  211102, -- Perfect Deadly Sapphire
  211103, -- Perfect Hungering Ruby
  211108, -- Perfect Masterful Amethyst
  211110, -- Perfect Quick Topaz
  220369, -- Perfect Stalwart Pearl
  211105, -- Perfect Sustaining Emerald
  211101, -- Perfect Swift Opal
  220373, -- Perfect Versatile Diamond
  211107, -- Quick Topaz
  220370, -- Stalwart Pearl
  211125, -- Sustaining Emerald
  211124, -- Swift Opal
  220374, -- Versatile Diamond
}

local Cogwheels = {
  217983, -- Disengage
  218046, -- Spirit Walk
  218043, -- Wild Charge
  218004, -- Vanish
  218108, -- Dark Pact
  218109, -- Death's Advance
  218005, -- Stampeding Roar
  218110, -- Soulshape
  216629, -- Blink
  218003, -- Leap of Faith
  218045, -- Door of Shadows
  216632, -- Sprint
  218044, -- Pursuit of Justice
  216630, -- Heroic Leap
  218082, -- Spiritwalker's Grace
  216631, -- Roll
  217989, -- Trailblazer
}

local BuffScrolls = {
  217605, -- Timeless Scroll of Intellect
  217606, -- Timeless Scroll of Fortitude
  217607, -- Timeless Scroll of the Wild
  217608, -- Timeless Scroll of Battle Shout
  217730, -- Timeless Scroll of Chaos
  217731, -- Timeless Scroll of Mystic Power
}

local Utility = {
  217928, -- Timeless Scroll of Resurrection
  217929, -- Timeless Scroll of Cleansing
  217956, -- Timeless Scroll of Summoning
}

local Flasks = {
  217904, -- Timerunner's Draught of Power
  217905, -- Timerunner's Draught of Health
}

local allItems = {
  {metaCategoryName, MetaGems},
  {prismaticCategoryName, Prismatic},
  {tinkerCategoryName, Tinkers},
  {cogwheelCategoryName, Cogwheels},
  {buffScrollsCategoryName, BuffScrolls},
  {utilityCategoryName, Utility},
  {flasksCategoryName, Flasks},
}

for _, itemList in pairs(allItems) do
  local category = itemList[1]
  for _, itemID in pairs(itemList[2]) do
    if C_Item.GetItemInfoInstant(itemID) then
      categories:AddItemToCategory(itemID, category)
    end
  end
end


local timerunningConfigOptions = {
  createCategory = {
    name = L:G("Timerunning"),
    type = "group",
    inline = true,
    args = {
      helpText = {
        type = "description",
        name = L:G("Disable categories here to prevent the plugin from claiming items if you want to create your own.\nAutomatic category names can be changed here."),
        order = 0,
      },
      header = {
        type = "header",
        order = 1,
        name = "",

      },
      Options = {
        type = "group",
        name = L:G("Options"),
        order = 2,
        args = {
          metaName = {
            type = "input",
            name = "Meta Gems label",
            order = 0,
            get = function() return metaCategoryName end,
            set = function(_, value) metaCategoryName = value print (value) end,
          },
          metaEnabled = {
            type = "toggle",
            name = "Enabled",
            desc = "Meta Gems category enabled",
            order = 1,
            get = function() return metaCategoryEnabled end,
            set = function(_, value) metaCategoryEnabled = value print (value) end,
          },
          PrismaticName = {
            type = "input",
            name = "Prismatic Gems label",
            order = 2,
            get = function() return prismaticCategoryName end,
            set = function(_, value) prismaticCategoryName = value end,
          },
          PrismaticEnabled = {
            type = "toggle",
            name = "Enabled",
            desc = "Prismatic Gems category enabled",
            order = 3,
            get = function() return prismaticCategoryEnabled end,
            set = function(_, value) prismaticCategoryEnabled = value end,
          },
          TinkerName = {
            type = "input",
            name = "Tinker Gems label",
            order = 4,
            get = function() return tinkerCategoryName end,
            set = function(_, value) tinkerCategoryName = value end,
          },
          TinkerEnabled = {
            type = "toggle",
            name = "Enabled",
            desc = "Tinker Gems category enabled",
            order = 5,
            get = function() return tinkerCategoryEnabled end,
            set = function(_, value) tinkerCategoryEnabled = value end,
          },
          CogwheelName = {
            type = "input",
            name = "Cogwheel Gems label",
            order = 6,
            get = function() return cogwheelCategoryName end,
            set = function(_, value) cogwheelCategoryName = value end,
          },
          CogwheelEnabled = {
            type = "toggle",
            name = "Enabled",
            desc = "Cogwheel Gems category enabled",
            order = 7,
            get = function() return cogwheelCategoryEnabled end,
            set = function(_, value) cogwheelCategoryEnabled = value end,
          },
          BuffScrollsName = {
            type = "input",
            name = "BuffScrolls label",
            order = 8,
            get = function() return buffScrollsCategoryName end,
            set = function(_, value) buffScrollsCategoryName = value end,
          },
          BuffScrollsEnabled = {
            type = "toggle",
            name = "Enabled",
            desc = "Class Buff category enabled",
            order = 9,
            get = function() return buffScrollsCategoryEnabled end,
            set = function(_, value) buffScrollsCategoryEnabled = value end,
          },
          utilityName = {
            type = "input",
            name = "Timerunning utility label",
            order = 10,
            get = function() return utilityCategoryName end,
            set = function(_, value) utilityCategoryName = value end,
          },
          utilityEnabled = {
            type = "toggle",
            name = "Enabled",
            desc = "Utility category enabled",
            order = 11,
            get = function() return utilityCategoryEnabled end,
            set = function(_, value) utilityCategoryEnabled = value end,
          },
          flasksName = {
            type = "input",
            name = "Flasks label",
            order = 12,
            get = function() return flasksCategoryName end,
            set = function(_, value) flasksCategoryName = value end,
          },
          Enabled = {
            type = "toggle",
            name = "Enabled",
            desc = "Flasks category enabled",
            order = 13,
            get = function() return flasksCategoryEnabled end,
            set = function(_, value) flasksCategoryEnabled = value end,
          },
        },
      },
      wipe = {
        type = "execute",
        name = L:G("Apply Changes"),
        order = 3,
        disabled = pendingChanges,
        func = function() categories:ReprocessAllItems() end,
      },

    }
  }
}

--[[
if (config.AddPluginConfig) then
  config:AddPluginConfig("Timerunning", timerunningConfigOptions)
else
  print ("BetterBags_Timerunning NOT loaded. Betterbags Plugin API Incompatible. Update to BetterBags v0.1.27-5 alpha or newer")
end
]]--