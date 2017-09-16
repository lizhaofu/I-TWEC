<%@ taglib prefix="c" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>I-TWEC</title>

    <script src="<c:url value="js/vendor/jquery.min.js" />"></script>
    <script src="<c:url value="js/vendor/d3.min.js" />"></script>
    <script src="<c:url value="js/gui/datGui/dat.gui.js" />"></script>
    <!-- Bootstrap core CSS -->

    <link rel="stylesheet" href="<c:url value="css/vendor/bootstrap.min.css"/>">
    <link rel="stylesheet" href="<c:url value="css/reset.css" />">
    <link rel="stylesheet" href="<c:url value="css/style.css"/>">
    <link rel="stylesheet" href="<c:url value="css/loadingBar.css"/>">
    <link rel="stylesheet" href="<c:url value="css/barChart.css"/>">
    <link rel="stylesheet" href="<c:url value="css/sentimentLabel.css"/>">
    <link rel="stylesheet" href="<c:url value="css/dashboard.css" />">
    <link rel="stylesheet" href="<c:url value="css/dat-gui-light-theme.css"/>">

</head>

<body>

<nav class="navbar navbar-fixed-top">
    <div class="container-fluid navbar-con">
        <div class="navbar-header col-sm-3 col-md-2">
            <a class="navbar-brand" href="#">I-TWEC</a>
        </div>
        <form method="post" id="fileForm" enctype="multipart/form-data">

            <input type="file" name="file" id="fileLoad"
                   style="visibility: hidden;"/>
            <input type="number" name="clusterThreshold" id="clusterThreshold" min=0 step="0.001" value="0.3"
                   style="visibility: hidden;"/>
            <input type="number" name="clusterLimit" id="clusterLimit" min=0 value="100" style="visibility: hidden;"/>
            <input type="number" name="sentimentThreshold" id="sentimentThreshold" min=0 value="0.8"
                   style="visibility: hidden;"/>
            <input type="number" name="shortTextLength" id="shortTextLength" min=0 value="15"
                   style="visibility: hidden;"/>
            <input type="number" name="embeddingDimension" id="embeddingDimension" min=0 value="100"
                   style="visibility: hidden;"/>
            <input type="submit"
                   id="fileUpload" value="Upload File" style="visibility: hidden;"/>
        </form>
        <ul class="nav navbar-nav nav-button">
            <li>
                <a href="javascript:void(0)" onclick="onLoad(this)" id="filename" class="btn btn-default">No file
                    chosen</a>
            </li>
            <li id="fileSubmit"></li>
            <li>
                <ul>
                    <li id="sentimentFirst" style="display: none;"></li>
                    <li id="sentimentSecond" style="display: none;"></li>
                </ul>
            </li>
            <li id="sentimentSubmit" style="display: none;">
                <a href="javascript:void(0)" onclick="onSentimentSubmit()" class="btn btn-default">Merge</a>
            </li>
        </ul>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <ul class="nav nav-sidebar " id="navDynamicBar">
            </ul>
        </div>

        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main"
             id="baseDiv">

            <div class="row"></div>
            <hr>
            <div class="overlay">
                <div class="loading-container">
                    <div class="loading"></div>
                    <div id="loading-text">loading</div>
                </div>
            </div>

            <div class="row" id="mainSection">

                <div class="col-xs-6 col-sm-9">
                    <p>I-TWEC is an interactive clustering tool for Twitter. Using
                        substring similarity as basis, I-TWEC is able to cluster tweets
                        in linear space and time complexity. The resulting clusters have
                        high lexical intra-cluster similarity and the end-user is able to
                        merge these clusters based on semantic relatedness.
                    <p>
                        I-TWEC is composed of two parts: Tweet Clustering Tool (TWEC) and
                        its interactive part. TWEC is a stand-alone application which is
                        able lexically cluster tweets and it is written in Java. It uses
                        abahgat's <a href="https://github.com/abahgat/suffixtree">Generalized
                        Suffix Tree</a> implementation as its underlying structure.
                    <p>I-TWEC is the interactive part of the algorithm and it
                        works together with TWEC. I-TWEC is written with Java Servlets
                        and require TWEC as a dependency to work correctly. Using I-TWEC,
                        the end-user is able to adjust lexical clustering and semantic
                        relatedness thresholds, merge clusters and export
                        clustering/evaluation results.
                    <p>
                        You can set I-TWEC up with a Java Runtime Environment and Tomcat.
                        The source code and instructions to set up I-TWEC can be found on
                        <a href="https://github.com/merterpam/I-TWEC">Github</a>.
                    <p>You can use this site to upload and cluster your own Twitter
                        data in I-TWEC. The uploaded data should contain one tweet at a
                        line. In the data, tweets can have labels for evaluations
                        purposes. These labels can added at the end of each line,
                        separated from the tweet by a \t character. Tweet labels are
                        optional and not required for clustering. Because we use tab
                        character as a seperator, tweets should not contain any \t. Below
                        is an example of input data with tweet labels:
                    <pre class="col-xs-6 col-sm-9">
							<code>
This is a sample tweet #sampleTweet \t SampleTweet
This is another sample tweet #sampleTweet \t SampleTweet
Lorem ipsum dolor sit amet, consectetur adipiscing elit \t LoremIpsum
							</code>
						</pre>

                </div>
            </div>
            <div class="table responsive" id="table"></div>
        </div>
    </div>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script>
    var clusterResponse = null;
    var sentimentResponse = null;
</script>

<script src="<c:url value="js/vendor/bootstrap.min.js" />"></script>
<script defer src="<c:url value="js/plugins.js" />"></script>

<script src="<c:url value="js/gui/bubbleChart/CustomTooltip.js" />"></script>
<script src="<c:url value="js/gui/bubbleChart/bubbleChart.js" />"></script>
<script src="<c:url value="js/gui/barChart/barChart.js" />"></script>
<script src="<c:url value="js/gui/dependencyWheel/composerBuilder.js" />"></script>
<script src="<c:url value="js/gui/dependencyWheel/d3.dependencyWheel.js"/>"></script>
<script src="<c:url value="js/content/dashboard.js"/>"></script>
<script src="<c:url value="js/content/sentiment.js"/>"></script>
<script src="<c:url value="js/content/export.js"/>"></script>
<script src="<c:url value="js/content/controller.js"/>"></script>

<script>
    window.jQuery
    || document
        .write('<script src="<c:url value="assets/js/vendor/jquery.min.js" />"><\/script>')
</script>

<script src="<c:url value="assets/js/ie10-viewport-bug-workaround.js" />"></script>
</body>
</html>
