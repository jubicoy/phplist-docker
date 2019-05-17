<?php
/**
 * PlaceholderPlugin for phplist
 * 
 * This file is a part of PlaceholderPlugin.
 *
 * This plugin is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This plugin is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * @category  phplist
 * @package   PlaceholderPlugin
 * @author    Duncan Cameron
 * @copyright 2014 Duncan Cameron
 * @license   http://www.gnu.org/licenses/gpl.html GNU General Public License, Version 3
 */

 /**
 * Registers the plugin with phplist
 */

class PlaceholderPlugin extends phplistPlugin
{
    const VERSION_FILE = 'version.txt';
    const PLUGIN = 'PlaceholderPlugin';

    /*
     *  Inherited variables
     */
    public $name = 'Placeholder Plugin';
    public $authors = 'Duncan Cameron';
    public $description = 'Provides additional placeholders for use in campaign emails.';
    public $enabled = 1;
    public $settings;

	private function replaceDate($content)
	{
		$format = str_replace('\\\\', '\\', getConfig('placeholder_dateformat'));
		return str_ireplace('[DATE]', date($format), $content);
	}

    public function __construct()
    {
        $this->coderoot = dirname(__FILE__) . '/' . self::PLUGIN . '/';
        $this->version = (is_file($f = $this->coderoot . self::VERSION_FILE))
            ? file_get_contents($f)
            : '';
		$this->settings = array(
			'placeholder_dateformat' => array (
			'value' => 'F j, Y',
			'description' => s('php date format'),
			'type' => 'text',
			'allowempty' => false,
			'category'=> 'Placeholder',
			)
		);
        parent::__construct();
    }

	public function parseOutgoingHTMLMessage($messageid, $content, $destination, $userdata = null)
	{
		return $this->replaceDate($content);
	}

	public function parseOutgoingTextMessage($messageid, $content, $destination, $userdata = null)
	{
		return $this->replaceDate($content);
	}

}

