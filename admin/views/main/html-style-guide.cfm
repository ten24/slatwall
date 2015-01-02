<br/>
<h2 style="font-weight:bold;">Slatwall Admin Style Guide</h2>

<hr />

<h1 id="headings">Buttons</h1>

<div class="row">
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-primary">Primary Button</button>
	</div>
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-warning">Warning Button</button>
	</div>
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-default">Default Button</button>
	</div>
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-danger">Danger Button</button>
	</div>
</div>
<br/>
<div class="row">
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-success">Success Button</button>
	</div>
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-inverse">Inverse Button</button>
	</div>
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-info">Info Button</button>
	</div>
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg btn-default disabled">Disabled Button</button>
	</div>
</div>
<br/>
<div class="row">
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg s-btn-ten24">Call To Action Button</button>
	</div>
	<div class="col-xs-3">
		<button href="#fakelink" class="btn btn-block btn-lg s-btn-dgrey">Dark Grey</button>
	</div>
</div>

<hr />

<h1 id="headings">Alerts</h1>
<div class="alert alert-warning">
	<strong>Warning Message!</strong> Lorem ipsum dolor sit amet, consectetur adipisicing elit. 
</div>
<div class="alert alert-error">
	<strong>Error Message!</strong> Numquam quos fuga quam suscipit sapiente perferendis magnam. 
</div>
<div class="alert alert-success">
	<strong>Success Message!</strong> Totam officiis dolorum voluptatibus maxime molestiae iste.
</div>
<div class="alert alert-info">
	<strong>Info Message!</strong> Consequatur facere deleniti cumque ducimus maiores nemo.
</div>

<hr />

<h1 id="headings">Toggle Content Component</h1>


<!--////////////////////////////////Toggle Content Component///////////////////////////////////-->
	<div ng-controller="CollapseDemoCtrl">
		<button class="btn btn-primary" ng-click="isCollapsed = !isCollapsed">Toggle collapse</button>
		
		<div collapse="isCollapsed">
			<div>Some content...</div> 
		</div>
	</div>
	
	<script>
		angular.module('slatwalladmin').controller('CollapseDemoCtrl', function ($scope) {
			$scope.isCollapsed = false;
		});
	</script>
<!--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Toggle Content Component End\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\-->


<hr/>

<h1 id="headings">Headings with Text</h1>

<h1>Heading 1</h1>
<p>Lorem ipsum dolor sit amet, adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl.</p>
<h2>Heading 2</h2>
<p>Lorem ipsum dolor sit amet, adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl.</p>
<h3>Heading 3</h3>
<p>Lorem ipsum dolor sit amet, adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl.</p>
<h4>Heading 4</h4>
<p>Lorem ipsum dolor sit amet, adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl.</p>
<h5>Heading 5</h5>
<p>Lorem ipsum dolor sit amet, adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl.</p>
<h6>Heading 6</h6>
<p>Lorem ipsum dolor sit amet, adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl.</p>

<hr />

<h1 id="paragraph">Paragraph</h1>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem.</p>
<p>Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl. Praesent mattis, massa quis luctus fermentum, turpis mi volutpat justo, eu volutpat enim diam eget metus. Maecenas ornare tortor.</p>

<p><img alt="Placeholder Image and Some Alt Text" src="http://placehold.it/350x150" title="A title element for this placeholder image."></p>

<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem.</p>

<blockquote>
	"This is a blockquote. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl."
</blockquote>

<hr/>


<h1 id="headings">Create List Component</h1>


	<!--////////////////////////////////Create List Component///////////////////////////////////-->
	<div class="s-select-list-wrapper"><!--- Add select component Wrapper --->
		
		<div class="form-group"><!--- Option select field wrapper --->
			<div class="input-group">
				<div class="s-input-btn">
					<input id="searchinput" type="search" class="form-control">
					<span class="glyphicon glyphicon-remove"></span>
					<!---<i class="fa fa-refresh fa-spin"></i>---><!--- Loading Icon --->
				</div>
				<div class="input-group-btn">
					<button class="btn btn-sm btn-primary" type="submit"><i class="fa fa-plus"></i></button>
				</div>
			</div>
		</div>
		
		<div class="s-selected-list"><!--- Selected options wrapper --->
			
			<div class="alert s-selected-item"><!--- Example Item 2 --->
				<button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<strong>Search Result Title 1</strong>
			</div>
			
			<div class="alert s-selected-item"><!--- Example Item 2 --->
				<button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<strong>Search Result Title 2</strong>
			</div>
			
		</div>
		
	</div>
	<!--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Create List Component End\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\-->
	
	<hr />
	
	<h1 id="headings">Create List Component With Dropdown</h1>
	
	<!--//////////////////////////////////Create List Component With Dropdown/////////////////////////////////-->
	<div class="s-select-list-wrapper s-dropdown"><!--- Add select component Wrapper --->
		
		<div class="form-group"><!--- Option select field wrapper --->
			<div class="input-group">
				<div class="s-input-btn">
					<input id="searchinput" type="search" class="form-control">
					<span class="glyphicon glyphicon-remove"></span>
					<!---<i class="fa fa-refresh fa-spin"></i>---><!--- Loading Icon --->
				</div>
				<div class="input-group-btn">
					<button class="btn btn-sm btn-default" type="submit"><i class="fa fa-caret-down"></i></button>
					<button class="btn btn-sm btn-primary" type="submit"><i class="fa fa-plus"></i></button>
				</div>
			</div>
		</div>
		
		<div class="dropdown s-search-results-wrapper"><!--- Dropdown wrapper --->
			<ul class="dropdown-menu">
				<li><a href="##">Item One</a></li> 
				<li><a href="##">Item Two</a></li> 
				<li><a href="##">Item Three</a></li> 
				<li><a href="##">Item Four</a></li> 
				<li><a href="##">Item Five</a></li> 
			</ul>
		</div>	
		
		<div class="s-selected-list"><!--- Selected options wrapper --->
			
			<div class="alert s-selected-item"><!--- Example Item 2 --->
				<button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<strong>Search Result Title 1</strong>
			</div>
			
			<div class="alert s-selected-item"><!--- Example Item 2 --->
				<button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<strong>Search Result Title 2</strong>
			</div>
			
		</div>
		
	</div>
	
	<script charset="utf-8">
		//Not for production use
		$('.s-select-list-wrapper input').focusin(function() {
			$('.s-search-results-wrapper').show();
		}).focusout(function () {
			$('.s-search-results-wrapper').hide();
		});
		$('.s-search-results-wrapper').hide();
	</script>
	<!--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Create List Component With Dropdown End\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\-->
	
<hr />

	<h1 id="text-elements"> Text Elements</h1>

	<p>The <a href="#">a element</a> example</p>
	<p>The <abbr>abbr element</abbr> and an <abbr title="Abbreviation">abbr</abbr> element with title examples</p>
	<p>The <acronym title="A Cowboy Ran One New York Marathon">ACRONYM</acronym> element example
	<p>The <b>b element</b> example</p>
	<p>The <cite>cite element</cite> example</p>
	<p>The <code>code element</code> example</p>
	<p>The <em>em element</em> example</p>
	<p>The <del>del element</del> example</p>
	<p>The <dfn>dfn element</dfn> and <dfn title="Title text">dfn element with title</dfn> examples</p>
	<p>The <i>i element</i> example</p>
	<p>The <ins>ins element</ins> example</p>
	<p>The <kbd>kbd element</kbd> example</p>
	<p>The <mark>mark element</mark> example</p>
	<p>The <q>q element</q> example</p>
	<p>The <q>q element <q>inside</q> a q element</q> example</p>
	<p>The <s>s element</s> example</p>
	<p>The <samp>samp element</samp> example</p>
	<p>The <small>small element</small> example</p>
	<p>The <span>span element</span> example</p>
	<p>The <strong>strong element</strong> example</p>
	<p>The <sub>sub element</sub> example</p>
	<p>The <sup>sup element</sup> example</p>
	<p>The <u>u element</u> example</p>
	<p>The <var>var element</var> example</p>
	
	<hr />
	
	<h1 id="monospace">Monospace / Preformatted</h1>
	<p>Code block wrapped in "pre" and "code" tags</p>
	<pre><code>// Loop through Divs using Javascript.
		var divs = document.querySelectorAll('div'), i;
		
		for (i = 0; i < divs.length; ++i) {
			divs[i].style.color = "green";
		}</code></pre>
		<p>Monospace Text wrapped in "pre" tags</p>
		<pre><p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam dignissim convallis est. Quisque aliquam. Donec faucibus. Nunc iaculis suscipit dui. Nam sit amet sem. Aliquam libero nisi, imperdiet at, tincidunt nec, gravida vehicula, nisl.</p></pre>
		
		<hr />
		
		<h1 id="list_types">List Types</h1>
		
		<h3>Ordered List</h3>
		<ol>
			<li>List Item 1</li>
			<li>List Item 2</li>
			<li>List Item 3</li>
		</ol>
		
		<h3>Unordered List</h3>
		<ul>
			<li>List Item 1</li>
			<li>List Item 2</li>
			<li>List Item 3</li>
		</ul>
		
		<h3>Definition List</h3>
		<dl>
			<dt>Definition List Term 1</dt>
			<dd>This is a definition list description.</dd>
			<dt>Definition List Term 2</dt>
			<dd>This is a definition list description.</dd>
			<dt>Definition List Term 3</dt>
			<dd>This is a definition list description.</dd>
		</dl>
		
		<hr />
		
		<h1 id="tables">Tables</h1>
		
		<table cellspacing="0" cellpadding="0">
			<tr>
				<th>Table Header 1</th><th>Table Header 2</th><th>Table Header 3</th>
			</tr>
			<tr>
				<td>Division 1</td><td>Division 2</td><td>Division 3</td>
			</tr>
			<tr class="even">
				<td>Division 1</td><td>Division 2</td><td>Division 3</td>
			</tr>
			<tr>
				<td>Division 1</td><td>Division 2</td><td>Division 3</td>
			</tr>
		</table>
		
		<hr />
		
		<h1 id="form_elements">Media and Form Elements</h1>
		
		<p>This last section contains elements that don't render well in markdown. Please consult the final section in <a href="https://github.com/bryanbraun/poor-mans-styleguide/blob/gh-pages/index.html">index.html</a>, to see the rest of the styleguide.</p>
		
		<h2>Media</h2>
		
		<p>The Audio Element:</p>
		<audio controls>
			<source src="http://www.w3schools.com/tags/horse.ogg" type="audio/ogg">
				<source src="http://www.w3schools.com/tags/horse.mp3" type="audio/mpeg">
					Your browser does not support the audio element.
				</audio>
				
				<p>The Video Element:</p>
				<video width="320" height="240" controls>
					<source src="http://www.w3schools.com/tags/movie.mp4" type="video/mp4">
						<source src="http://www.w3schools.com/tags/movie.ogg" type="video/ogg">
							Your browser does not support the video tag.
						</video>
						
						<h2>Form Elements</h2>
						
						<fieldset>
							
							<form>
								
								<div class="form-group">
									<label class="control-label">Text Field</label>
									<input type="text" class="form-control" />
								</div>
							
								<div class="form-group s-required">
									<label class="control-label">Required Text Field</label>
									<input type="text" class="form-control" />
									<span id="helpBlock" class="help-block">Required fields must have the s-required class on the form-group div.</span>
								</div>
								
								<div class="form-group has-error">
									<label class="control-label">Text Field Error</label>
									<input type="text" class="form-control" />
									<span id="helpBlock" class="help-block">Required fields must have the s-error class on the form-group div.</span>
								</div>
								
								<div class="form-group">
									<label class="control-label">Text Area</label>
									<textarea class="form-control"></textarea>
								</div>
									
								<div class="form-group">
									<label>Select Element</label>
									<select class="form-control" name="select_element">
										<optgroup label="Option Group 1">
											<option value="1">Option 1</option>
											<option value="2">Option 2</option>
											<option value="3">Option 3</option>
										</optgroup>
										<optgroup label="Option Group 2">
											<option value="1">Option 1</option>
											<option value="2">Option 2</option>
											<option value="3">Option 3</option>
										</optgroup>
									</select>
								</div>
									
											
											
								<div class="form-group">
									<label for="radio_buttons">Radio Buttons:</label>
									<div class="radio">
										<input type="radio" name="radio" id="radio1" value="option1">
										<label for="radio1">
											Radio One
										</label>
									</div>
									<div class="radio">
										<input type="radio" name="radio" id="radio2" value="option2">
										<label for="radio2">
											Radio Two
										</label>
									</div>
									<div class="radio">
										<input type="radio" name="radio" id="radio3" value="option3">
										<label for="radio3">
											Radio Three
										</label>
									</div>
								</div>
											
											
								<div class="form-group">
									<label for="checkboxes">Checkboxes:</label>
									<div class="s-checkbox">
										<input type="checkbox" id="checkbox1">
										<label for="checkbox1"> Checkbox One</label>
									</div>
									<div class="s-checkbox">
										<input type="checkbox" id="checkbox2">
										<label for="checkbox2"> Checkbox Two</label>
									</div>
									<div class="s-checkbox">
										<input type="checkbox" id="checkbox3">
										<label for="checkbox3"> Checkbox Three</label>
									</div>
								</div>
								
								<div class="form-group">
									<label for="password">Password:</label>
									<input type="password" class="password form-control" name="password" />
								</div>
								
								<div class="form-group">
									<label for="file">File Input:</label>
									<input type="file" class="file" name="file" />
								</div>
											
											
								<h3>HTML5-specific Form Elements</h3>
								
								<div class="form-group">
									<label for="email">Email:</label>
									<input type="email" class="form-control">
								</div>
								
								<div class="form-group">
									<label for="url">URL:</label>
									<input type="url" class="form-control">
								</div>
								
								<div class="form-group">
									<label for="tel">Telephone:</label>
									<input type="tel" class="form-control">
								</div>
								
								<div class="form-group">
									<label for="number">Number:</label>
									<input type="number" min="0" max="10" step="1" value="5" class="form-control">
								</div>
								
								<div class="form-group">
									<label for="search">Search:</label>
									<input type="search" class="form-control">
								</div>
								
								<div class="form-group">
									<label for="date">Date:</label>
									<input type="date" class="form-control">
								</div>
								
								<div class="form-group">
									<label for="time">Time:</label>
									<input type="time" class="form-control">
								</div>
								
								<div class="form-group">
									<label for="color">Color:</label>
									<input type="color">
								</div>
								
								<div class="form-group">
									<label for="datalist">Datalist:</label>
									<input list="browsers" name="browser" type="datalist" class="form-control">
									<datalist id="browsers">
										<option value="Internet Explorer">
										<option value="Firefox">
										<option value="Chrome">
										<option value="Opera">
										<option value="Safari">
									</datalist>
								</div>		
								<div class="form-group">
									<label for="range">Range:</label>
									<input type="range" name="points" min="1" max="10">
								</div>
													
								<div class="form-group">
									<input class="button" type="reset" value="Clear" /> <input class="button" type="submit" value="Submit" />
								</div>
							</form>
												
						</fieldset>
											
						<!-- End of Styleguide -->